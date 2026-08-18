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
        # Nixos
        h0t2Hardware
        experimentalFeatures
        age
        deployUser

        # Programs & Config
        git
        fish

        # Services
        newt
        paperless
        postgres

        # Utils
        ensureDirs
      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      # boot.loader.grub.enable = true;
      # boot.loader.grub.device = "/dev/nvme0n1p1";
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = host; # Define your hostname.

      # Configure network connections interactively with nmcli or nmtui.
      networking.networkmanager.enable = true;

      # Block ipv6
      networking.nftables.enable = true;
      networking.nftables.ruleset = ''
        table ip6 filter {
          chain input {
            type filter hook input priority 0;
            policy drop;
          }
        }
      '';

      # from /etc/ssh/ssh_host_ed25519_key.pub
      age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJB0m5CGrE6RBEMpQLmM1gR0BhRAtxSxRn9WfjNCu90N root@h0t2";
      # age.secrets."ssh-authorized-keys".rekeyFile = ../../../secrets/ssh-authorized-keys.age; # OpenSSH config doesn't allow for making that a secret...
      age.secrets."tailscale-auth-key".rekeyFile = ../../../secrets/tailscale-auth-key.age;

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
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORD/6qz7wZxaZZwF37bNQad4KZYVEzeeCOsorCRfpNs"
        ];
      };

      environment.variables = {
        EDITOR = "hx";
        TERM = "xterm-256color";
      };

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/cncptpr/nixfiles"; # sets NH_OS_FLAKE variable for you
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
          nix-output-monitor
          bat
          jq
          ripgrep
        ]
        ++ (with self.packages.${stdenv.hostPlatform.system}; [
          # Wrapped Packages
          tmux
        ]);

      # Onedrive Backup Upload
      systemd.timers."backup-upload-onedrive" = {
        description = "Run backup upload once a day";
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
        description = "Run backup upload once";
        script = ''
          CONFIG_PATH=/mass/config/homelab/backrest/rclone/rclone.conf
          LOCAL_PATH=/mass/backups/backrest/h0T2-data-config/
          REMOTE_PATH=onedrive:homelab/backups/backrest/h0T2-data-config/

          ${pkgs.rclone}/bin/rclone --config "$CONFIG_PATH" sync "$LOCAL_PATH" "$REMOTE_PATH" -vv
        '';
      };

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
