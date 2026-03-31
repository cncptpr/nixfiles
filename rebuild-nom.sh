sudo nixos-rebuild switch --flake . --log-format internal-json -v |& nix run nixpkgs#nix-output-monitor -- --json
