{ self, ... }: {
  flake.nixosModules.base = { pkgs, ... }: {
    imports = with self.nixosModules; [
      experimentalFeatures
      cncptprUser
      locales

      # Programs & Config
      git
      fish
      tmux
    ];

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      btop
      curl
      file
      helix
      jq
      nil
      ripgrep
      tree
      yazi
    ];

    environment.variables = {
      EDITOR = "hx";
      TERM = "xterm-256color";
    };

  };
}
