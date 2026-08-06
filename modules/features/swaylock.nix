{ self, ... }: {
  flake.wrapper.swaylock = { wlib, ... }: {
    imports = [ wlib.wrapperModules.swaylock ];
    settings = {
      image = "/home/cncptpr/Pictures/Wallpapers/wallhaven_43vjmv.jpg";
      show-failed-attempts = true;
      show-keyboard-layout = true;
      indicator-caps-lock = true;
    };
  };

  flake.wrapper.swayidle-lock =
    {
      wlib,
      lib,
      pkgs,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      swaylock = self.packages.${system}.swaylock;
      lockScript = ''
        systemctl --user start swayidle-timeout.service
        ${lib.getExe swaylock} # blockes until unlocked
        loginctl unlock-session
        systemctl --user stop swayidle-timeout.service
      '';
    in
    {
      imports = [ wlib.wrapperModules.swayidle ];
      events.lock = lockScript;
      events.before-sleep = lockScript;
    };

  flake.wrapper.swayidle-timeout =
    {
      wlib,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.swayidle ];
      timeouts = [
        {
          timeout = 5;
          command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
          commandResume = "${lib.getExe pkgs.niri} msg action power-on-monitors";
        }
      ];
    };

  flake.nixosModules.swaylock = { ... }: {
    # systemd.user.services.swayidle-lock = {
    #   enable = true;
    #   description = "Noctalia Shell";
    #   after = [ "graphical-session.target" ];
    #   # partOf = "graphical-session.target";

    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${lib.getExe pkgs.noctalia}";
    #     Restart = "on-failure";
    #     RestartSec = "2";
    #   };

    #   wantedBy = [ "default.target" ];
    # };
  };
}
