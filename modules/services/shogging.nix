{ inputs, ... }: {
  flake.nixosModules.shogging = { config, ... }: {
    imports = [ inputs.shogging.nixosModules.default ];

    age.secrets."shogging-nextcloud-passwordfile".rekeyFile =
      ../../secrets/shogging-nextcloud-passwordfile.age;

    services.shogging = {
      enable = true;
      # motto = "";
      caldav = {
        host = "https://cloud.fsim-ev.de/";
        username = "bot";
        calendar = "AK-Einkauf (FSIM)";
        passwordFile = config.age.secrets."shogging-nextcloud-passwordfile".path;
      };
      port = 1234;
    };

    custom.reverse-proxy.shogging = {
      name = "Shogging";
      port = config.services.shogging.port;
      domain = "shogging.cncptpr.xyz";
      authentication = true;
    };

  };
}
