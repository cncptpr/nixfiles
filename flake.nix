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
      url = "github:ar175-lol/zen-browser-flake-fix/fix/policies";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode/v2.0.32";
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

    shogging = {
      url = "github:cncptpr/shogging";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ensure-dirs = {
      url = "github:cncptpr/ensure-dirs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    leaf = {
      url = "github:RivoLink/leaf";
      flake = false;
    };
    sping = {
      url = "github:LambdaBytes/sping";
      flake = false;
    };
    dealve-tui = {
      url = "github:kurama/dealve-tui";
      flake = false;
    };
    photocraft = {
      url = "github:nolight132/photocraft-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    signal-whisper = {
      # url = "git+file:///home/cncptpr/Projects/signal-whisper";
      # url = "github:haennes/signal-whisper";
      url = "github:cncptpr/signal-whisper/allow-all-voice-messages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake {
      inputs = inputs;
    } (inputs.import-tree ./modules);
}
