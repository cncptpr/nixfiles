{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.l4pt2Configuration =
    { pkgs, ... }:
    let
      host = "l4pt2";
    in
    {
      imports = with self.nixosModules; [
        l4pt2Hardware

        base
        graphical
        dev
        dealveTui
        nerdlog

        age
        nmProfiles
        deployScripts
        nixd
        opencode
      ];

      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "usbasp-udev-rules";
          text = ''
            SUBSYSTEM=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", MODE="0660", TAG+="uaccess"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="c7b4", MODE="0660", TAG+="uaccess"
          '';
          destination = "/etc/udev/rules.d/70-usbasp.rules";
        })
      ];

      boot.loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
        };
        efi.canTouchEfiVariables = true;
      };

      services.openssh.enable = true;

      custom.niri.useExternalConfig = true;

      # from /etc/ssh/ssh_host_ed25519_key.pub
      age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfBgczI9u0+I8Q2nD50Kqm8uym/c/O2gY+DshEkb8h9 root@l4pt2";
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # Must be set because openssh is not enabled

      networking.hostName = host;
      networking.networkmanager.enable = true;

      services.tailscale.enable = true;

      environment.systemPackages = with pkgs; [
        monocraft

        gh
        lazygit
        devenv

        ghgrab

        bat
        herdr
        nix-output-monitor

        eduvpn-client

        thunderbird

        agent-browser
        chromium

        ddgr
      ];

      virtualisation.libvirtd.enable = true;
      users.groups.libvirt.members = [ "cncptpr" ];

      virtualisation.virtualbox.host.enable = true;
      users.extraGroups.vboxusers.members = [ "cncptpr" ];

      system.stateVersion = "26.05"; # Do not change

    };
}
