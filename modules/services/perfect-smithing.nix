{ inputs, ... }: {
  flake.nixosModules.perfectSmithing =
    { config, pkgs, ... }:
    let
      # perfect-smithing pins wasm-bindgen = "=0.2.127" in its Cargo.toml, and
      # cargo-leptos requires the CLI to match that version exactly. nixpkgs'
      # default wasm-bindgen-cli is newer, so build with the versioned package
      # that matches the Rust dependency.
      package =
        inputs.perfect-smithing.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
          (old: {
            nativeBuildInputs = builtins.map (
              pkg: if (pkg.pname or "") == "wasm-bindgen-cli" then pkgs.wasm-bindgen-cli_0_2_127 else pkg
            ) old.nativeBuildInputs;
          });
    in
    {
      imports = [ inputs.perfect-smithing.nixosModules.default ];

      services.perfect-smithing = {
        enable = true;
        inherit package;
        port = 3030;
      };

      custom.reverse-proxy.perfect-smithing = {
        name = "Perfect Smithing";
        port = config.services.perfect-smithing.port;
        domain = "smithing.cncptpr.xyz";
      };
    };
}
