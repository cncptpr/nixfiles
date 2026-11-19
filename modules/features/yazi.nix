{ self, inputs, ... }:
{
  flake.wrappers.yazi = { pkgs, ... }: {
    imports = [ inputs.nix-yazi-plugins.wrapperModules.yaziWithPlugins ];

    # Everything enabled for testing; remove the ones that do not fit.
    yaziPlugins = {
      bookmarks.enable = true;
      bypass.enable = true;
      chmod.enable = true;
      copy-file-contents.enable = true;
      exifaudio.enable = true;
      full-border.enable = true;
      git.enable = true;
      glow.enable = true;
      jump-to-char.enable = true;
      open-with-cmd.enable = true;
      ouch.enable = true;
      recycle-bin.enable = true;
      relative-motions.enable = true;
      rich-preview.enable = true;
      smart-enter.enable = true;
      smart-filter.enable = true;
      starship.enable = true;
      system-clipboard.enable = true;
      torrent-preview.enable = true;
      whoosh.enable = true;
      yamb.enable = true;
      yatline.enable = true;
      toggle-pane.enable = true;
    };
  };

  flake.nixosModules.yazi = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.yazi ];
  };
}
