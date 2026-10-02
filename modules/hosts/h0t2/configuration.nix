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
      pkgs,
      ...
    }:

    {
      imports = with self.nixosModules; [
        # Nixos
        base
        h0t2Hardware
        h0t2BackupOnedrive
        age
        deployUser
        blockIPv6
        openssh

        # Services
        newt
        paperless
        postgres
        radicale
        # languagetool
        perfectSmithing

        # Utils
        ensureDirs
      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = host;
      networking.networkmanager.enable = true;

      # from /etc/ssh/ssh_host_ed25519_key.pub
      age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJB0m5CGrE6RBEMpQLmM1gR0BhRAtxSxRn9WfjNCu90N root@h0t2";

      age.secrets."tailscale-auth-key".rekeyFile = ../../../secrets/tailscale-auth-key.age;
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "server";
        authKeyFile = config.age.secrets."tailscale-auth-key".path;
      };

      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
        bat
        gh
        lazygit
        nil
        nix-output-monitor
      ];

      system.stateVersion = "26.05";

    };
}
