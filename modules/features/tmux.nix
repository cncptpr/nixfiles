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
      '';
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
