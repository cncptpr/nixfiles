# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  self,
  ...
}:
let
  host = "reversed2";
  number_wg_clients = 3;
in
{
  flake.nixosModules.reversed2Configuration =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {

      imports = [
        self.nixosModules.reversed2Hardware
        self.nixosModules.experimentalFeatures
        self.nixosModules.git
        self.nixosModules.age
      ];

      # from /etc/ssh/ssh_host_ed25519_key.pub
      age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5SUtLQfW/1IE6TO9nkekxaHYM3D72qWjMVPJMIS5Yv root@nixos";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
      };

      networking.hostName = host;

      networking = {
        interfaces.ens18.ipv4.addresses = [
          {
            address = "185.119.16.106";
            prefixLength = 32;
          }
        ];
        nameservers = [ "1.1.1.1" ];
        firewall.enable = false;
        defaultGateway = {
          address = "37.114.36.0";
          interface = "ens18";
        };
      };

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

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "de";
        variant = "";
      };

      # Configure console keymap
      console.keyMap = "de";
      programs.fish = {
        enable = true;
        shellAliases = {
          gs = "git status";
          ga = "git add -A";
          gc = "git commit";
          gp = "git push";
          gd = "git diff";
          adog = "git log --all --decorate --oneline --graph";
        };
      };
      services.openssh.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.cncptpr = {
        isNormalUser = true;
        description = "cncptpr";
        extraGroups = [ "wheel" ];
        shell = pkgs.fish;
        packages = with pkgs; [
          helix
          zellij
          yazi
          nil
          nix-output-monitor
          git
          curl
        ];
      };

      environment.variables = {
        EDITOR = "hx";
        TERM = "xterm-256color";
      };

      age.secrets = {
        "wg-${host}-server".rekeyFile = ../../../secrets/wg-${host}-server.age;
      }
      // lib.mergeAttrsList (
        map (i: {
          "wg-${host}-client-${toString i}".rekeyFile = ../../../secrets/wg-${host}-client-${toString i}.age;
        }) (lib.range 1 number_wg_clients)
      );

      # networking.wg-quick.interfaces.wg0.configFile = config.age.secrets."wg-${host}-server".file;
      networking.wg-quick.interfaces.wg0.configFile = config.age.secrets."wg-${host}-server".path;

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        #   #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        #   #  wget
        iptables # Required by wireguard
      ];

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

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    };
}
