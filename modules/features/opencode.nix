{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      # Use the nixpkgs rev that opencode v2 publishes its node_modules hash
      # against, so no hash override is needed.
      pkgs = inputs.nixpkgs-opencode.legacyPackages.${system};

      # The v2 flake's nix expression fails at install time: its postInstall
      # runs `opencode completion`, which is not a subcommand in v2 and gets
      # parsed as a directory positional (chdir("completion")), breaking shell
      # completion generation. Apply the pinned patch to the source and reuse
      # upstream's node_modules.nix / opencode.nix unchanged.
      src = pkgs.applyPatches {
        name = "opencode-v2-patched";
        src = inputs.opencode;
        patches = [ ./opencode-v2-no-completions.patch ];
      };

      node_modules = pkgs.callPackage "${src}/nix/node_modules.nix" { };

      opencode = pkgs.callPackage "${src}/nix/opencode.nix" {
        inherit node_modules;
      };
    in
    {
      packages.opencode = opencode;
    };
}