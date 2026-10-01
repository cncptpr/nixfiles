{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.l4pt2Configuration =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      host = "l4pt2";
    in
    {
      imports = with self.nixosModules; [
        l4pt2Hardware

        base
        graphical

        age
        nmProfiles
        deployScripts
        nixd

        opencode
      ];

      boot.loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
        };
        efi.canTouchEfiVariables = true;
      };

      custom.niri.useExternalConfig = true;

      # from /etc/ssh/ssh_host_ed25519_key.pub
      age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfBgczI9u0+I8Q2nD50Kqm8uym/c/O2gY+DshEkb8h9 root@l4pt2";
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # Must be set because openssh is not enabled

      networking.hostName = host;
      networking.networkmanager.enable = true;

      services.tailscale.enable = true;

      environment.systemPackages = with pkgs; [
        gh
        lazygit
        devenv

        ghgrab

        bat
        herdr
        nix-output-monitor

        thunderbird
        inputs.leaf.packages.${system}.default
      ];

      virtualisation.libvirtd.enable = true;
      users.groups.libvirt.members = [ "cncptpr" ];

      system.stateVersion = "26.05"; # Do not change

    };
}
