{
  flake.nixosModules.dev = {pkgs, ...}:{
    environment.systemPackages = with pkgs; [
      # Git
      lazygit
      gh
      forgejo-cli
      
      # Typst
      tinymist

      # Gleam
      gleam

      # Rust
      cargo
      cargo-leptos
      rust-analyzer
      rustc
      clippy
      bacon

      # Scripts
      python3
      uv
      nodejs

      # C/C++
      libclang
      clang-tools
      gcc
      gnumake
      cmake
      meson
      ninja
    ];
  };
}
