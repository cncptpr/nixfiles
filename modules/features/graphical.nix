{ self, ... }: {
  flake.nixosModules.graphical = { pkgs, ... }: {

    imports = with self.nixosModules; [
      niri
      zenBrowser
    ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clipboard-x11

      signal-desktop
    ];

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.printing.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      }
    ];

  };
}
