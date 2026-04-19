{ pkgs, config, ... }:
{
  programs.fastfetch = let
    color = "{#blue}";
    top =    "{#}┏━━━━━━━━━━┫${color}";
    side =   "{#}┃${color}";
    bottom = "{#}┗━━━━━━━━━━";
  in {
    enable = true;
    package = pkgs.callPackage ../packages/fastfetch/default.nix {};
    settings = {
      logo = {
        source = "nixos_medium";
        padding = {
          right = 3;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        # separator = "  ";
      };
      modules = [
        "break"
        {
          type = "title";
          format = "${top} {user-name}@{host-name}";
        }
        { type = "os"; key = "${side} OS"; }
        { type = "kernel"; key = "${side} Kernel"; }
        { type = "host"; key = "${side} Host"; }
        { type = "packages"; key = "${side} Packages"; }
        { type = "uptime"; key = "${side} Uptime"; }
        # { type = "bios"; key = "${side} BIOS Version"; }
        { type = "custom"; format = bottom; }

        "break"
        { type = "custom"; format = "${top} System Resources"; }
        { type = "cpu"; key = "${side} CPU"; }
        { type = "gpu"; key = "${side} GPU"; }
        {
          type = "memory";
          key = "${side} Memory";
          format = "{total}";
          percent = {
            green = 50;
            yellow = 70;
          };
        }
        {
          type = "battery";
          key = "${side} Battery";
          format = "{model-name} {technology} - {charge_full} mAh ({cycle-count} cycles)";
        }
        { type = "physicaldisk"; key = "${side} Physical Disk"; }
        { type = "custom"; format = bottom; }

        "break"
        { type = "custom"; format = "${top} Peripherals"; }
        {
          type = "display";
          key = "${side} Display";
          format = "{width}x{height} @ {refresh-rate} Hz {inch}\" [{type}] - {name}";
        }
        {
          type = "btrfs";
          key = "${side} Btrfs";
          percent = {
            green = 70;
            yellow = 85;
          };
        }
        {
          type = "disk";
          key = "${side} Disk ({mountpoint})";
          percent = {
            green = 70;
            yellow = 85;
          };
        }
        "poweradapter"
        { type = "custom"; format = bottom; }

        "break"
        { type = "custom"; format = "${top} Environment"; }
        { type = "wm"; key = "${side} Window Manager"; }
        # { type = "vulkan"; key = "${side} Vulkan"; }
        { type = "theme"; key = "${side} Theme"; }
        { type = "icons"; key = "${side} Icon Theme"; }
        { type = "cursor"; key = "${side} Cursor"; }
        { type = "font"; key = "${side} Font"; }
        { type = "custom"; format = bottom; }
      ];
    };
  };
}
