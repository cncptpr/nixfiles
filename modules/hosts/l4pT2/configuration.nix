{
  self,
  inputs,
  ...
}:
let
  host = "l4pt2";
in
{
  flake.nixosModules.l4pt2Configuration =
    { config, pkgs, ... }:
    {
      imports = with self.nixosModules; [
        l4pt2Hardware
        experimentalFeatures
        git
        fish
        niri
        # age
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = host;
      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
      console.keyMap = "de";

      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      
      services.printing.enable = true;
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      users.users."cncptpr" = {
        isNormalUser = true;
        description = "cncptpr";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.fish;
      };

      services.tailscale = {
        enable = true;
      };

      programs.firefox.enable = true;

      nixpkgs.config.allowUnfree = true;

      environment.variables = {
        EDITOR = "hx";
        TERM = "xterm-256color";
      };

      environment.systemPackages =
        with pkgs;
        [
          # Dev
          helix
          gh
          git
          lazygit

          # Nix Stuff
          nil

          # Other
          file
          yazi
          curl
          herdr
        ]
        ++ (with self.packages.${stdenv.hostPlatform.system}; [
          # Wrapped Packages
          tmux
        ]);

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/cncptpr/nixfiles"; # sets NH_OS_FLAKE variable for you
      };

      system.stateVersion = "26.05"; # Do not change

    };
}
