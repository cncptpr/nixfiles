{
  flake.nixosModules.radicale =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = {
        age.secrets."radicale-users" = {
          rekeyFile = ../../secrets/radicale-users.age;
          owner = config.services.radicale.user;
          group = config.services.radicale.group;
        };

        services.radicale = {
          enable = true;
          settings = {
            server =
              let
                port = toString config.custom.radicale.port;
              in
              {
                hosts = [
                  "127.0.0.1:${port}"
                  # "0.0.0.0:${port}"
                  # "[::]:${port}"
                ];
              };
            auth = {
              type = "htpasswd";
              # Edit this file with `htpasswd` from the `apacheHttpd` package.
              # `htpasswd -5 -c ./secrets/non-age/radicale-users <user>`
              htpasswd_filename = config.age.secrets."radicale-users".path;
              htpasswd_encryption = "autodetect";
            };

            storage.filesystem_folder = "/mass/data/radicale/storage";

            web = {
              type = "radicale_infcloud";
              # The weird spacing here is on purpose to hack the INI formatter...
              infcloud_config = ''
                globalInterfaceLanguage = "de_DE";
                                globalTimeZone = "Europe/Berlin";
              '';
            };

          };
          rights = {
            root = {
              user = ".+";
              collection = "";
              permissions = "R";
            };
            principal = {
              user = ".+";
              collection = "{user}";
              permissions = "RW";
            };
            calendars = {
              user = ".+";
              collection = "{user}/[^/]+";
              permissions = "rw";
            };
          };

          package =
            let
              package = (
                # Taken from https://gitlab.com/nobodyinperson/yannix/-/blob/main/nixosModules/services/radicale/infcloud.nix
                # pkgs.infcloud.override { withConfig = cfg.config; }
                pkgs.infcloud
              );
            in
            pkgs.radicale.overrideAttrs (oldAttrs: {
              pname = "${oldAttrs.pname}+infcloud";
              # https://github.com/Kozea/Radicale/wiki/Client-InfCloud
              # inject the infcloud source into radicale's source
              postInstall = "ln -s ${package} $out/${pkgs.python3.sitePackages}/${oldAttrs.pname}/web/internal_data/infcloud";
            });
        };

        custom.ensureDirs.radicale-init-dirs =
          let
            cfg = config.services.radicale;
          in
          {
            before = [ config.systemd.services.radicale.name ];
            dirs = [ cfg.settings.storage.filesystem_folder ];
            user = cfg.user;
            group = cfg.group;
          };

        services.newt.blueprint.proxy-resources.radicale = {
          auth.sso-enabled = false;
          full-domain = "radicale.cncptpr.xyz";
          name = "Radicale";
          protocol = "http";
          targets = [
            {
              hostname = "localhost";
              method = "http";
              port = config.custom.radicale.port;
            }
          ];
        };
      };

      options = {
        custom.radicale.port = lib.mkOption {
          description = "Radicale's Port";
          default = 5232;
          type = lib.types.int;
        };
      };
    };
}
