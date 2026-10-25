# Never EVER use home manager again!!!!

{ inputs, ... }: {
  flake.nixosModules.zenBrowser =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      defaultCfg = {
        installation_mode = "force_installed";
        private_browsing = true;
        default_area = "menupanel";
      };
      zenBrowserConfed = inputs.zen-browser.packages.${system}.twilight-unwrapped.override {
        extraPolicies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          ExtensionSettings = {
            "*" = {
              installation_mode = "blocked";
              blocked_install_message = "Addons managed by Nix";
            };
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = defaultCfg // {
              default_area = "navbar";
            }; # bitwarden
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = defaultCfg; # vimium
            "addon@darkreader.org" = defaultCfg; # darkreader
            "idcac-pub@guus.ninja" = defaultCfg; # I still don't care about cookies
            "uBlock0@raymondhill.net" = defaultCfg; # uBlock
            "languagetool-webextension@languagetool.org" = defaultCfg; # languagetool
          };
        };
      };
      zenBrowserPkg = pkgs.wrapFirefox zenBrowserConfed { };
    in
    {
      environment.systemPackages = [
        zenBrowserPkg
        # zenBrowserConfed
      ];
    };
}
