let
  main-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnyx15yATERx55O38TsVldST7u2eXX8fAsv15L6AhLE";
in {
  "openconnect.age" = {
    publicKeys = [main-key];
    armor = true;
  };
}
