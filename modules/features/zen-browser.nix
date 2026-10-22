{ self, inputs, ... }: {
  flake.homeModules.zenBrowser = { ... }: {
    imports = [ inputs.zen-browser.homeModules.twilight ];
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      policies =
        let
          defaultCfg = {
            installation_mode = "force_installed";
            private_browsing = true;
            default_area = "menupanel";
          };
        in
        {
          DisableAppUpdate = true;
          OfferToSaveLogins = false;
          ExtensionSettings = {
            "*" = {
              installation_mode = "blocked";
              blocked_install_message = "Addons managed by Nix.";
            };
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = defaultCfg // {
              default_area = "navbar";
            }; # bitwarden
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = defaultCfg; # vimium
            "addon@darkreader.org" = defaultCfg; # darkreader
            "idcac-pub@guus.ninja" = defaultCfg // {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/idcac-pub@guus.ninja/latest.xpi";
            }; # I still don't care about cookies
            "uBlock@raymondhill.net" = defaultCfg; # uBlock
          };
        };
    };
  };

  flake.nixosModules.zenBrowser = { config, ... }: {
    imports = [
      inputs.zen-browser.inputs.home-manager.nixosModules.default
    ];
    home-manager = {
      users."cncptpr" = { ... }: {
        imports = [
          self.homeModules.zenBrowser
        ];
        home.stateVersion = config.system.stateVersion;
      };
    };
  };
}
