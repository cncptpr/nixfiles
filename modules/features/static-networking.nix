{ self, lib, ... }:
{
  options = {
    staticNetworking = {
      address = lib.mkOption {
        description = "Server's IP Address";
        type = lib.types.str;
      };
      prefixLength = lib.mkOption {
        description = "IP Address' Prefix Length (e.g. the /24 part)";
        type = lib.types.number;
      };
      gateway = lib.mkOption {
        description = "Server's Gateway IP Address";
        type = lib.types.str;
      };
      interface = lib.mkOption {
        description = "Default Networking Interface";
        default = "ens18";
      };
    };
  };

  config =
    let
      cfg = self.custom.staticNetworking;
    in
    {
      flake.nixosModules.staticNetworking =
        { ... }:
        {
          networking = {
            interfaces."${cfg.interface}".ipv4.addresses = [
              {
                address = cfg.address;
                prefixLength = cfg.prefixLength;
              }
            ];
            nameservers = [ "1.1.1.1" ];
            firewall.enable = false;
            defaultGateway = {
              address = cfg.gateway;
              interface = cfg.interface;
            };
          };
        };
    };
}
