{ self, inputs, ... }:
let
  spkgs = pkgs: self.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  flake.nixosModules.leaf = { pkgs, ... }: {
    environment.systemPackages = [ (spkgs pkgs).leaf ];
  };

  flake.wrappers.leaf =
    {
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      package = (spkgs pkgs).leaf-unwrapped;
      env = {
        LEAF_EDITOR = "${lib.getExe pkgs.helix} +{$line}";
      };
    };

  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.leaf-unwrapped = pkgs.rustPlatform.buildRustPackage {
        pname = "leaf-markdown-viewer";
        version = "1.28.2";

        src = inputs.leaf;
        cargoLock.lockFile = "${inputs.leaf}/Cargo.lock";

        meta = with pkgs.lib; {
          description = "Terminal Markdown previewer with a GUI-like experience";
          homepage = "https://leaf.rivolink.mg";
          license = licenses.mit;
          mainProgram = "leaf";
        };

        doCheck = false;
      };
    };
}
