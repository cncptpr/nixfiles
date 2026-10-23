{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.sping = pkgs.rustPlatform.buildRustPackage {
        pname = "sping";
        version = "1.7.1";

        src = pkgs.fetchFromGitHub {
          owner = "LambdaBytes";
          repo = "sping";
          rev = "v1.7.1";
          hash = "sha256-CcwTgmKJQ/5ER5K8RbGDQXU3tZfxImwbzW5c6z+EWD4=";
        };

        cargoHash = "sha256-RlweO+MiO8vE8SVorxfNmEMDvI66LL/ZAytnlo3hii0=";
      };
    };
}
