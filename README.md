# My System Configuration

A collection of scripts, dotfiles, a NixOS configuration, and a custom packages.

## To Do

### Short Term

- [ ] Rice
  - [ ] Screen brightness bar on change
  - [ ] Revamp quickshell
  - [ ] Back to square and minimalism
  - [ ] Fix firefox file manager popup
  - [ ] Switch to nushell
  - [ ] Redo fastfetch
  - [ ] Hyprland `graphical-session.target`
  - [ ] Fix bitwarden float by ensuring it is removed from any window groups before forcing float
- [ ] Build tooling around `./upstream-diff.sh` that can check the todo-tree and notify when manual PR inclusion can be removed
- [ ] Flake parts
  - [x] Split config out for desktop versus laptop
  - [ ] Modularize home manager config
- [ ] Redo everything on my desktop system
  - [x] Figure out disk encryption
  - [ ] Figure out best use for HDD+SSD
- [ ] Finally add a lock screen to hyprland
- [ ] Nohang
  - [ ] Never kill hyprland
  - [ ] Never kill nix-daemon (builds are ok)
- [ ] Figure out the mail situation
  - [ ] Thunderbird run in background?
  - [x] ~~Declarative kmail?~~
  - [x] ~~Auto unlock kwallet~~
- [ ] Declarative vimium config
- [ ] Automate upstream checks for changes to packages that are patched/overridden
- [ ] Proper QT Theming
  - [ ] Functional Polkit authentication for KDE applications (e.g. partitionmanager)
    - [ ] Figure out why `QT_STYLE_OVERRIDE=kvantum` breaks `polkit-kde-authentication-agent-1`
- [ ] Fix PNPM download text jitter by disabling the standard progress bar. Might need nixpkgs edit
- [ ] Hyprland: add bind for assigning a workspace to a different monitor. Rofi or maybe quickshell?
- [ ] Try out Liam's transparency effect on unfocused windows with a bit of a frosted glass twist and some animations

### Long Term

- Fingerprint reader
- Revisit fingerprint reader + PAM
- Package Problems:
  - Packages don't respect `NIX_BUILD_CORES`
      - [x] `firmware-manager`
      - [ ] `jetbrains-jdk-jcef-21.0.9-b`
      - [ ] `python3.13-django-5.2.12`
      - [ ] `rapidocr-onnxruntime`
      - [ ] `nix-store-tests`
      - [ ] `triton-llvm`
      - [ ] `perl5.42.0-Test2-Harness-1.000161` checkPhase
      - [ ] `python3-minimal`
      - [ ] `go`
      - [ ] `numpy`
      - [ ] `librsvg-2.62.3-i686-linux`
      - [ ] `ffmpeg-headless` checkPhase
      - [ ] `sqlite` checkPhase
  - Packages having problems due to `.git` being missing (see: a lot of the LLVM packages)
  - Some packages don't build in parallel
    - `lager`
- Status bar:
  - Low battery color indication
  - nohang activity indicator module
- Mount basically everything with `nosuid`.
  See [this](https://discourse.nixos.org/t/get-size-of-nix-store-efficiently/51354/8).

sudo nixos-install --flake /mnt/home/ben/config#desktop --log-format bar-with-logs --max-jobs 1 --cores 16
