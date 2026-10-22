{ inputs, ... }: {
  flake.nixosModules.dev = {pkgs, ...}:{
    environment.systemPackages = with pkgs; [
      # Git
      lazygit
      gh
      forgejo-cli #fj
      
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

      # Python
      python3
      uv
      ty
      ruff

      # JS
      nodejs
      pnpm

      # C/C++
      libclang
      clang-tools
      gcc
      gnumake
      cmake
      meson
      ninja
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
