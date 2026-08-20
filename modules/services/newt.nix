{
  flake.nixosModules.newt = { config, ... }: {

    age.secrets.newt-conf.rekeyFile = ../../secrets/newt-conf.age;

    services.newt = {
      enable = true;
      settings = {
        endpoint = "https://pangolin.cncptpr.xyz";
      };
      environmentFile = config.age.secrets.newt-conf.path;
    };
  };
}
