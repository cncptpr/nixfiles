{ self, ... }:
{
  flake.wrappers.helix =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.helix ];

      settings = {
        theme = "gruvbox-material";

        editor = {
          line-number = "relative";
          true-color = true;

          auto-save.after-delay = {
            enable = true;
            timeout = 0;
          };

          lsp.display-messages = true;
          file-picker.hidden = false;
        };

        keys.normal = {
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          "`" = [ "switch_to_uppercase" ];
          "´" = [ "switch_to_lowercase" ];
        };
      };
    };

  flake.nixosModules.helix =
    { pkgs, ... }:
    {
      environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.helix ];
    };
}
