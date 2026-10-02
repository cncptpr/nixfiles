{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    leaf = {
      url = "github:cncptpr/leaf-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode/v2";
      flake = false;
    };
    # Toolchain the opencode v2 nix package publishes its node_modules hashes
    # for (see opencode/nix/hashes.json); avoid hash overrides by building it
    # with the same pinned nixpkgs. Bump together with the v2 input above.
    nixpkgs-opencode = {
      url = "github:nixos/nixpkgs/9dd5558b06dbdacbf635a3dd36dce1b1a7ee3a89";
    };

    perfect-smithing = {
      url = "github:cncptpr/perfect-smithing";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake {
      inputs = inputs;
    } (inputs.import-tree ./modules);
}
