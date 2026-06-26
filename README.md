# My System Configuration

A collection of scripts, dotfiles, a NixOS configuration, and a custom packages.

## To Do

### Short Term

- [ ] Flake parts
  - [x] Split config out for desktop versus laptop
  - [ ] Modularize home manager config
- [ ] Redo everything on my desktop system
  - [x] Figure out disk encryption
  - [ ] Figure out best use for HDD+SSD
- [ ] Finally add a lock screen to hyprland
- [ ] Switch to limine
  - [x] Make sure it works in removable/fallback mode for desktop (dumb MSI bios)
  - [ ] Theme it properly
- [ ] Make nohang never kill hyprland
- [ ] Figure out the main situation - [ ] Declarative kmail?
  - [ ] Auto unlock kwallet
- [ ] Declarative vimium config
- [ ] Automate upstream checks for changes to packages that are patched/overridden

### Long Term

- Fingerprint reader
- Revisit fingerprint reader + PAM
- Fix the evaluation warning: 
  ```
  pkgs.buildEnv warning: colliding subpath (ignored): `/nix/store/788mx070y81zjlg5ipcl0cra3afviw9k-gcc-wrapper-15.2.0/bin/cpp' and `/nix/store/86ghvdw2dyw702cyb8c6hs86ilp1kwyn-clang-wrapper-21.1.8/bin/cpp'
  ```
- Package Problems:
  - Packages don't respect `NIX_BUILD_CORES`
      - [x] `firmware-manager`
      - [ ] `jetbrains-jdk-jcef-21.0.9-b`
      - [ ] `python3.13-django-5.2.12`
      - [ ] `rapidocr-onnxruntime`
      - [ ] `nix-store-tests`
      - [ ] `triton-llvm`
  - Packages having problems due to `.git` being missing (see: a lot of the LLVM packages)
  - Some packages don't build in parallel
    - `lager`
- Status bar:
  - Low battery color indication
  - nohang activity indicator module
- Mount basically everything with `nosuid`.
  See [this](https://discourse.nixos.org/t/get-size-of-nix-store-efficiently/51354/8).

sudo nixos-install --flake /mnt/home/ben/config#desktop --log-format bar-with-logs --max-jobs 1 --cores 16
