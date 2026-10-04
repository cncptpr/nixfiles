{ inputs, ... }: {
  flake.nixosModules.perfectSmithing = { config, ... }: {
    imports = [ inputs.perfect-smithing.nixosModules.default ];

    services.perfect-smithing = {
      enable = true;
      port = 3030;
    };

    services.newt.blueprint.proxy-resources.perfect-smithing = {
      auth.sso-enabled = false;
      full-domain = "smithing.cncptpr.xyz";
      name = "Perfect Smithing";
      protocol = "http";
      targets = [
        {
          hostname = "localhost";
          method = "http";
          port = config.services.perfect-smithing.port;
        }
      ];
    };
  };
}
