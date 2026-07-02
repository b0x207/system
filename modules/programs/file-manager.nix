{...}: {
  flake.nixosModules.file-manager = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kdePackages.dolphin
      thunar

      # According to the wiki:
      # > By default, dolphin by itself is not packaged with support for SVG icons.
      kdePackages.qtsvg
      kdePackages.kio-admin # For the 'open as admin' in dolphin

      # Extra thumbnail generators
      ffmpeg-headless
      ffmpegthumbnailer
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kdesdk-thumbnailers
      gdk-pixbuf
      libheif.bin # provides heif-thumbnailer (the program that generates HEIF thumbnails)
      libheif.out # provides heif.thumbnailer (allows for the viewing of HEIF thumbnails)
      webp-pixbuf-loader

      # Compression
      kdePackages.ark
    ];

    # Thumbnails
    services.tumbler.enable = true;
  };
}
