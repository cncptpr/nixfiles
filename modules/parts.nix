{ inputs, lib, ... }: {
  options = {
    # To allow flake-parts to merge deploy configs
    flake.deploy = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.attrs;
      default = { };
    };
  };
  imports = [ inputs.wrapper-modules.flakeModules.default ];
  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
