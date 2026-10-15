# I hate building Electron
{ ... }: {
  flake.overlays.electron-bin = _final: prev: {
    electron = prev.electron-bin;
    electron_42 = prev.electron_42-bin;
  };
}
