{ inputs, ... }: {
  flake.nixosModules.shogging = { config, ... }: {
    imports = [ inputs.shogging.nixosModules.default ];

    age.secrets."shogging-caldav-passwordfile".rekeyFile =
      ../../secrets/shogging-caldav-passwordfile.age;

    services.shogging = {
      enable = true;
      motto = "Running against Radicale";
      caldav = {
        host = "http://localhost:${toString config.custom.radicale.port}/";
        username = "timon";
        calendar = "Shopping List";
        passwordFile = config.age.secrets."shogging-caldav-passwordfile".path;
      };
      port = 1234;
    };

    services.newt.blueprint.proxy-resources.shogging = {
      auth.sso-enabled = true;
      full-domain = "shogging.cncptpr.xyz";
      name = "Shogging";
      protocol = "http";
      targets = [
        {
          hostname = "localhost";
          method = "http";
          port = config.services.shogging.port;
        }
      ];
    };

  };
}
