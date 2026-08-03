{ inputs, ... }: {
  imports = [ inputs.wrapper-modules.flakeModules.default ];
  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
