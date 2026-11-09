{ self, inputs, ... }: {
  flake.nixosModules.base = { pkgs, ... }: {
    imports = with self.nixosModules; [
      experimentalFeatures
      cncptprUser
      locales
      udiskie

      # Programs & Config
      git
      fish
      tmux
    ];

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      btop
      curl
      dust
      fastfetch
      file
      helix
      jq
      nil
      ripgrep
      tree
      yazi
      libqalculate
      rclone
      pv
      nmap
      witr
    ];

    security.sudo.extraConfig = ''
      Defaults pwfeedback
      Defaults insults
    '';

    environment.variables = {
      EDITOR = "hx";
      TERM = "xterm-256color";
    };

  };
}
