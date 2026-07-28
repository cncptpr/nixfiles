{ inputs, ... }: {

  flake.homeModules.zenBrowser = { ... }: {
    imports = [ inputs.zen-browser.homeModules.twilight ];
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      policies =
        let
          mkExtensionSettings = builtins.mapAttrs (
            _: pluginId: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
              installation_mode = "force_installed";
            }
          );

        in
        {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          OfferToSaveLogins = false;
          # ExtensionSettings = mkExtensionSettings {
          #   "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bittorrent";
          #   "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium";
          #   "addon@darkreader.org" = "darkreader";
          #   "idcac-pub@guus.ninja" = "i still don't care about cookies";
          # };
        };
    };
  };

  # flake.nixosModules.zenBrowser =
  #   { pkgs, ... }:
  #   let
  #     system = pkgs.stdenv.hostPlatform.system;
  #     mkExtensionSettings = builtins.mapAttrs (
  #       _: pluginId: {
  #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
  #         installation_mode = "force_installed";
  #       }
  #     );
  #     zenBrowserPkg = inputs.zen-browser.packages.${system}.default.override {
  #       extraPolicies = {
  #         ExtensionSettings = mkExtensionSettings {
  #           "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bittorrent";
  #           "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium";
  #           "addon@darkreader.org" = "darkreader";
  #           "idcac-pub@guus.ninja" = "i still don't care about cookies";
  #         };
  #       };
  #     };
  #   in
  #   {
  #     environment.systemPackages = [
  #       zenBrowserPkg
  #     ];
  #   };
}
