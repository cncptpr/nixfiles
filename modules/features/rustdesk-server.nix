{
  self,
  lib,
  pkgs,
  ...
}:
{
  flake.nixosModules.rustdeskServer =
    { config, ... }:
    {
      containers.rustdesk = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.100.1";
        localAddress = "192.168.100.2";

        config =
          { pkgs, ... }:
          {
            networking.firewall = {
              enable = true;
              allowedTCPPorts = [ 21115 21116 21118 21119 ];
              allowedUDPPorts = [ 21117 ];
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
      };
      networking.firewall.allowedTCPPorts = [
        21115
        21116
        21118
        21119
      ];
      networking.firewall.allowedUDPPorts = [ 21117 ];
    };
}
