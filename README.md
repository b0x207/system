# My System Configuration

A collection of scripts, dotfiles, a NixOS configuration, and a custom packages.

## To Do

- Fingerprint reader
- Split config out for desktop versus laptop
- Flake parts?
- Grub UEFI settings entry
- Switch to limine?
  - Make sure it works in removable/fallback mode for desktop (dumb MSI bios)
- Revisit fingerprint reader + PAM
- Package Problems:
  - Packages don't respect `NIX_BUILD_CORES`
      - `firmware-manager`
      - `jetbrains-jdk-jcef-21.0.9-b`
      - `python3.13-django-5.2.12`
      - `rapidocr-onnxruntime`
      - `nix-store-tests`
      - `triton-llvm`
  - Packages having problems due to `.git` being missing (see: a lot of the LLVM packages)
  - Some packages don't build in parallel
    - `lager`
- Status bar:
  - Low battery color indication
  - nohang activity indicator module
- Make nohang never kill hyprland
- Mount basically everything with `nosuid`.
  See [this](https://discourse.nixos.org/t/get-size-of-nix-store-efficiently/51354/8).
