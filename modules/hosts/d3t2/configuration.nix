{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.d3t2Configuration =
    { lib, pkgs, ... }:
    let
      host = "d3t2";
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      imports = with self.nixosModules; [
        d3t2Hardware

        base
        graphical

        # age
        # nmProfiles

        openssh

        deployScripts
        nixd

        opencode
      ];

      boot.loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
        };
        efi.canTouchEfiVariables = true;
      };

      custom.niri.useExternalConfig = true;

      # from /etc/ssh/ssh_host_ed25519_key.pub
      # age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfBgczI9u0+I8Q2nD50Kqm8uym/c/O2gY+DshEkb8h9 root@l4pt2";
      # age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # Must be set because openssh is not enabled
      networking.hostName = host;
      networking.networkmanager.enable = true;
      networking.firewall.enable = false;

      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      services.tailscale = {
        enable = true;
      };

      programs.firefox.enable = true;

      nixpkgs.config.allowUnfree = true;

      environment.variables = {
        AGENT_BROWSER_EXECUTABLE_PATH = "${lib.getExe pkgs.chromium}";
      };

      environment.systemPackages = with pkgs; [
        gh
        lazygit
        devenv

        agent-browser
        chromium

        nil

        # Other
        herdr
        nix-output-monitor

        ntfs3g
        heroic
        lutris

        prismlauncher

        inputs.leaf.packages.${system}.default
      ];

      programs.steam.enable = true;

      ## Nvidia ##

      hardware.graphics.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        open = false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;
      };

      system.stateVersion = "26.05"; # Do not change

    };
}
