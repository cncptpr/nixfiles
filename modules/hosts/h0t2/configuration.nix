# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  self,
  ...
}:
let
  host = "h0t2";
in
{
  flake.nixosModules.h0t2Configuration =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      imports = with self.nixosModules; [
        # Include the results of the hardware scan.
        h0t2Hardware
        experimentalFeatures
        git
        fish
        age
      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      # boot.loader.grub.enable = true;
      # boot.loader.grub.device = "/dev/nvme0n1p1";
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = host; # Define your hostname.

      # Configure network connections interactively with nmcli or nmtui.
      networking.networkmanager.enable = true;

      # from /etc/ssh/ssh_host_ed25519_key.pub
      age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJB0m5CGrE6RBEMpQLmM1gR0BhRAtxSxRn9WfjNCu90N root@h0t2";
      # age.secrets."ssh-authorized-keys".rekeyFile = ../../../secrets/ssh-authorized-keys.age; # OpenSSH config doesn't allow for making that a secret...
      age.secrets."tailscale-auth-key".rekeyFile = ../../../secrets/tailscale-auth-key.age; # OpenSSH config doesn't allow for making that a secret...

      # TODO: extract into shared file
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

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      services.tailscale = {
        enable = true;
        useRoutingFeatures = "server";
        authKeyFile = config.age.secrets."tailscale-auth-key".path;
      };

      virtualisation.docker.enable = true;

      users.users.cncptpr = {
        isNormalUser = true;
        description = "cncptpr";
        extraGroups = [
          "wheel"
          "docker"
        ];
        shell = pkgs.fish;
        packages = with pkgs; [
          helix
          tmux
          yazi
          nil
          nix-output-monitor
          git
          curl
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORD/6qz7wZxaZZwF37bNQad4KZYVEzeeCOsorCRfpNs"
        ];
      };

      environment.variables = {
        EDITOR = "hx";
        TERM = "xterm-256color";
      };

      # Onedrive Backup Upload

      environment.systemPackages = with pkgs; [
        rclone # required by backup-upload-ondrive service
      ];

      systemd.timers."backup-upload-onedrive" = {
        description = "Run upload.fish once a day";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          # Optional: randomize start up to 1h to avoid thundering herd
          RandomizedDelaySec = "1h";
        };
        wantedBy = [ "timers.target" ];
      };

      systemd.services."backup-upload-onedrive" = {
        description = "Run upload.fish script once";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.fish}/bin/fish /mass/config/homelab/backrest/upload-timer/upload.fish";
          User = "root";
          Group = "root";
          Nice = 10;
        };
      };

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Select internationalisation properties.
      # i18n.defaultLocale = "en_US.UTF-8";
      # console = {
      #   font = "Lat2-Terminus16";
      #   keyMap = "us";
      #   useXkbConfig = true; # use xkb.options in tty.
      # };

      # Enable the X11 windowing system.
      # services.xserver.enable = true;

      # Configure keymap in X11
      # services.xserver.xkb.layout = "us";
      # services.xserver.xkb.options = "eurosign:e,caps:escape";

      # Enable CUPS to print documents.
      # services.printing.enable = true;

      # Enable sound.
      # services.pulseaudio.enable = true;
      # OR
      # services.pipewire = {
      #   enable = true;
      #   pulse.enable = true;
      # };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      # users.users.alice = {
      #   isNormalUser = true;
      #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      #   packages = with pkgs; [
      #     tree
      #   ];
      # };

      # programs.firefox.enable = true;

      # List packages installed in system profile.
      # You can use https://search.nixos.org/ to find more packages (and options).
      # environment.systemPackages = with pkgs; [
      #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #   wget
      # ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;

      # This option defines the first version of NixOS you have installed on this particular machine,
      # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
      #
      # Most users should NEVER change this value after the initial install, for any reason,
      # even if you've upgraded your system to a new NixOS release.
      #
      # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
      # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
      # to actually do that.
      #
      # This value being lower than the current NixOS release does NOT mean your system is
      # out of date, out of support, or vulnerable.
      #
      # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
      # and migrated your data accordingly.
      #
      # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "26.05"; # Did you read the comment?

    };
}
