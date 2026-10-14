{
  flake.nixosModules.dev = {pkgs, ...}:{
    environment.systemPackages = with pkgs; [
      # Typst
      tinymist

      # Gleam
      gleam

      # Rust
      cargo
      cargo-leptos
      rust-analyzer

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
