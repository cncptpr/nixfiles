{
  self,
  lib,
  pkgs,
  ...
}:
{
  flake.nixosModules.rustdeskServer =
    { config, pkgs, ... }:
    let
      ports = [
        { port = 21115; }
        { port = 21116; }
        {
          port = 21117;
          proto = "udp";
        }
        { port = 21118; }
        { port = 21119; }
      ];
      filterPorts =
        proto': ports:
        ports
        |> builtins.filter (
          {
            proto ? "tcp",
            ...
          }:
          proto == proto'
        )
        |> builtins.map ({ port, ... }: port);
      tcpPorts = filterPorts "tcp" ports;
      udpPorts = filterPorts "udp" ports;
    in
    {

      systemd.services.rustdesk-server = {
        description = "RustDesk Server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.rustdesk-server}/bin/hbbr";
          Restart = "on-failure";
        };
      };

      systemd.services.rustdesk-rendezvous = {
        description = "RustDesk Rendezvous Server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.rustdesk-server}/bin/hbbs";
          Restart = "on-failure";
        };
      };

      networking.firewall.allowedTCPPorts = tcpPorts;
      networking.firewall.allowedUDPPorts = udpPorts;
    };
}
