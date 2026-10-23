{ self, ... }:
{
  flake.wrappers.tmux =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.tmux ];
      modeKeys = "vi";
      statusKeys = "vi";
      vimVisualKeys = true;
      configBefore = ''
        set extended-keys on
        set -as terminal-features ",xterm-256color:RGB"
      '';
      terminal = "tmux";
    };

  flake.nixosModules.tmux =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      tmux = self.packages.${system}.tmux;
    in
    {
      environment.systemPackages = [ tmux ];
    };
}
