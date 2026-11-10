{ inputs, ... }: {
  flake.nixosModules.perfectSmithing = { config, ... }: {
    imports = [ inputs.perfect-smithing.nixosModules.default ];

    services.perfect-smithing = {
      enable = true;
      port = 3030;
    };

    custom.reverse-proxy.perfect-smithing = {
      name = "Perfect Smithing";
      port = config.services.perfect-smithing.port;
      domain = "smithing.cncptpr.xyz";
    };
  };
}
