{ self, inputs, ... }:
let
  system = pkgs: pkgs.stdenv.hostPlatform.system;
  get-stable-niri = pkgs: inputs.nixpkgs-stable.legacyPackages.${system pkgs}.niri;
  get-wrapped-niri = pkgs: self.packages.${system pkgs}.niri;
in
{
  flake.wrappers.niri =
    {
      pkgs,
      wlib,
      lib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.niri ];
      package = get-stable-niri pkgs;
      "config.kdl".content = builtins.readFile ../../config/niri/config.kdl;
    };

  flake.nixosModules.niri =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.custom.niri;
    in
    {
      options.custom.niri = {
        useExternalConfig = lib.mkOption {
          description = "If enabled, niri will look for a config in its normal config paths, instead of using the one included in this flake.";
          type = lib.types.bool;
          default = false;
        };
        installFallbackPackages = lib.mkOption {
          description = "If enabled, packages expected by the default niri config will be installed in addition to the ones used in the included config.";
          type = lib.types.bool;
          default = false;
        };
      };

      config = {
        programs.niri = {
          enable = true;
          package = if cfg.useExternalConfig then get-stable-niri pkgs else get-wrapped-niri pkgs;
        };

        environment.systemPackages =
          with pkgs;
          [
            vicinae
            noctalia
            wezterm
          ]
          ++ (
            if cfg.installFallbackPackages then
              (with pkgs; [
                waybar
                alacritty
                fuzzel
                swaylock
                orca
              ])
            else
              [ ]
          );

        systemd.user.services.vicinae = {
          enable = true;
          description = "Vicinae Server";
          after = [ "graphical-session.target" ];
          # partOf = "graphical-session.target";

          serviceConfig = {
            # Find a better way to inherit the normal PATH
            Environment = "PATH=/run/wrappers/bin:%h/.nix-profile/bin:/nix/profile/bin:%h/.local/state/nix/profile/bin:/etc/profiles/per-user/cncptpr/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
            Type = "simple";
            ExecStart = "${lib.getExe pkgs.vicinae} server";
            Restart = "on-failure";
            RestartSec = 2;
          };

          wantedBy = [ "default.target" ];
        };

        systemd.user.services.noctalia = {
          enable = true;
          description = "Noctalia Shell";
          after = [ "graphical-session.target" ];
          # partOf = "graphical-session.target";

          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe pkgs.noctalia}";
            Restart = "on-failure";
            RestartSec = "2";
          };

          wantedBy = [ "default.target" ];
        };
      };
    };
}
