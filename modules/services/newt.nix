{ self, ... }: {
  flake.nixosModules.newt = { config, lib, ... }: {
    imports = with self.nixosModules; [ reverseProxy ];

    age.secrets.newt-conf.rekeyFile = ../../secrets/newt-conf.age;

    services.newt = {
      enable = true;
      settings = {
        endpoint = "https://pangolin.cncptpr.xyz";
      };
      environmentFile = config.age.secrets.newt-conf.path;
      blueprint.proxy-resources = lib.mapAttrs (_: proxy: {
        auth.sso-enabled = proxy.authentication;
        full-domain = proxy.domain;
        name = proxy.name;
        protocol = "http";
        targets = [
          {
            hostname = proxy.url;
            method = "http";
            port = proxy.port;
          }
        ];
      }) config.custom.reverse-proxy;
    };
  };
}
