{
  self,
  lib,
  pkgs,
  ...
}:
{
  flake.nixosModules.rustdeskServer =
    { config, ... }:
    let
      localAddress = "192.168.100.2";
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
            proto ? "tcp",...
          }:
          proto == proto'
        )
        |> builtins.map ({ port, ... }: port);
      tcpPorts = filterPorts "tcp" ports;
      udpPorts = filterPorts "udp" ports;
    in
    {
      containers.rustdesk = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.100.1";
        localAddress = localAddress;

        config =
          { pkgs, ... }:
          {
            networking.firewall = {
              enable = true;
              allowedTCPPorts = tcpPorts;
              allowedUDPPorts = udpPorts;
            };

            networking.useHostResolvConf = lib.mkForce false;

            services.resolved.enable = true;

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

            system.stateVersion = "26.05";
          };
      };

      networking.nat = {
        enable = lib.mkDefault true;

        internalInterfaces = [ "ve-+" ];
        externalInterface = "ens18";

        forwardPorts =
          let
            forward = (
              {
                port,
                proto ? "tcp",
              }:
              {
                sourcePort = port;
                proto = proto;
                destination = "${localAddress}:${toString port}";
              }
            );
          in
          map forward ports;
      };

      networking.firewall.allowedTCPPorts = tcpPorts;
      networking.firewall.allowedUDPPorts = udpPorts;
    };
}
