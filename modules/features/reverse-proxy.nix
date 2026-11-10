{ ... }: {
  flake.nixosModules.reverseProxy = { lib, ... }: {
    options.custom.reverse-proxy = lib.mkOption {
      default = { };
      description = ''
        A general absraction / interface for reverse-proxies.
        Import another module 'implementing' this, e.g. newt.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Display name shown by the reverse proxy.";
            };
            url = lib.mkOption {
              type = lib.types.str;
              default = "localhost";
              description = "Internal target hostname or address.";
            };
            port = lib.mkOption {
              type = lib.types.port;
              description = "Internal target port.";
            };
            domain = lib.mkOption {
              type = lib.types.str;
              description = "Public domain name.";
            };
            authentication = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable Newt/Pangolin SSO authentication.";
            };
          };
        }
      );
    };
  };
}
