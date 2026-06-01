{...}: {
  flake.nixosModules.keyd = {...}: {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          main = {
            # capslock = "overload(control, esc)"
            capslock = "esc";
            esc = "capslock";
            leftalt = "layer(extension)";
          };
          extension = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          };
        };
      };
    };
  };
}
