{
  flake.nixosModules.newt = { config, ... }: {

    age.secrets.newt-conf.rekeyFile = ../../../secrets/newt-conf.age;

    services.newt = {
      enable = true;
      settings = {
        endpoint = "https://pangolin.cncptpr.xyz";
      };
      environmentFile = config.age.secrets.newt-conf.path;
      blueprint = {
        proxy-resources = {
          paperless = {
            auth.sso-enabled = false;
            full-domain = "paperless.cncptpr.xyz";
            name = "Paperless";
            protocol = "http";
            targets = [
              {
                hostname = "localhost";
                method = "http";
                port = config.services.paperless.port;
              }
            ];
          };
        };
      };
    };
  };
}
