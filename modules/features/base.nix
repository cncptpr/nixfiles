{ self, ... }: {
  flake.nixosModules.base = { pkgs, ... }: {
    imports = with self.nixosModules; [
      experimentalFeatures
      cncptprUser
      locales
      udiskie

      # Programs & Config
      git
      fish
      helix
      tmux
      mm
      yazi
    ];

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      btop
      curl
      dust
      fastfetch
      file
      jq
      nil
      ripgrep
      tree
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
