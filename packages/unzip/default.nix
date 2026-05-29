{pkgs, ...}: {
  unzip = pkgs.unzip.overrideAttrs {
    patches = [
      ./CVE-2021-4217.patch
    ];
  };
}
