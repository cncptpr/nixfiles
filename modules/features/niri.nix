{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
    in
    {

      programs.niri = {
        enable = true;
        package = pkgs-stable.niri;
      };

      environment.systemPackages = with pkgs; [
        pkgs-stable.vicinae
        noctalia
        wezterm
      ];

      systemd.user.services.vicinae = {
        enable = true;
        description = "Vicinae Server";
        after = [ "graphical-session.target" ];
        # partOf = "graphical-session.target";

        serviceConfig = {
          Environment = "PATH=%h/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin";
          Type = "simple";
          ExecStart = "${lib.getExe pkgs-stable.vicinae} server";
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
}
