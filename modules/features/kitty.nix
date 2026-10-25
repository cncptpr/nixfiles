{ self, ... }: {
  flake.wrappers.kitty = { wlib, ... }: {
    imports = [ wlib.wrapperModules.kitty ];
    settings = {
      hide_window_decorations = true;

      font_features = "JetBrainsMono Nerd Font";
      allow_remote_control = "no";
      window_margin_width = "1 10";

      enable_audio_bell = "no";
      background_opacity = "0.9";

      # == Theme ==
      foreground = "#b2b2b2";
      background = "#000000";
      cursor = "#52ad70";
      cursor_text_color = "#000000";
      selection_background = "#40334d";

      color0 = "#000000";
      color1 = "#cc5555";
      color2 = "#55cc55";
      color3 = "#cdcd55";
      color4 = "#5455cb";
      color5 = "#cc55cc";
      color6 = "#7acaca";
      color7 = "#cccccc";
      color8 = "#555555";
      color9 = "#ff5555";
      color10 = "#55ff55";
      color11 = "#ffff55";
      color12 = "#5555ff";
      color13 = "#ff55ff";
      color14 = "#55ffff";
      color15 = "#ffffff";
    };
  };

  flake.nixosModules.kitty = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.kitty ];
  };
}
