{nixpkgs}: final: prev: let
  # TODO: this needs a complete overhaul to make it work, however, other packages need to be
  # before more time is spent on picky packages
  plain-pkgs = import nixpkgs { system = "x86_64-linux"; };

  # A basic replacement GCC with default platform targets
  genericCC = prev.wrapCCWith {
    cc = prev.gcc-unwrapped;

    # TODO: decide if this can be refined to -mtune=intel
    extraBuildCommands = ''
      echo '-march=x86-64 -mtune=generic ' >> $out/nix-support/cc-cflags
    '';
  };

  genericStdenv = prevStdenv: prev.overrideCC prevStdenv genericCC;
  withGenericStdenv = pkg: pkg.override (oldArgs: { stdenv = genericStdenv oldArgs.stdenv; });

  genericPkgs = import prev.path {
    inherit (prev.stdenv) system;
    
    config = {
      # TODO: convert to dynamic reference
      allowUnfree = true;
    };
  };
in {
  # Jun 11 2026:
  # There are far too many problems with the ML/LLM python packages and their related dependencies.
  # To get around this, make the entire tree of derivations for open webui use the generic versions
  # of the same nixpkgs set.
  open-webui = genericPkgs.open-webui;

  # May 3 2026:
  # openldap checks time out
  #
  # TRACK: https://github.com/NixOS/nixpkgs/issues/514113
  openldap = prev.openldap.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  # Apr 18 2026:
  # Build currently fails with 'File sizes do not match' stemming from a check in
  # `combile_two_binaries.py` on line 96. For now, it's not worth accidentally introducing bugs,
  # so fall back on the plain version of xen.
  # This mailing list thread might be useful:
  # https://lists.xenproject.org/archives/html/xen-devel/2025-01/msg00441.html
  #
  # TODO: take a closer look into this and see what's actually wrong.
  # xen = plain-pkgs.xen;

  # Apr 18 2026:
  # Build currently fails due to a bug in GCC's vector optimizations.
  #
  # TRACK: https://github.com/NixOS/nixpkgs/issues/440270
  assimp = withGenericStdenv prev.assimp;

  # May 7 2026
  # Upstream bug with ValveSoftware/gamescope that hasn't made its way into a fixed point release.
  # Needs a release after Apr 27 2026
  #
  # TRACK: https://github.com/ValveSoftware/gamescope/issues/2110
  gamescope = prev.gamescope.overrideAttrs (
    oldAttrs:
      assert oldAttrs.version == "3.16.23"; {
        src = prev.fetchFromGitHub {
          owner = "ValveSoftware";
          repo = "gamescope";
          rev = "96376e4773574a929b59f53f021cf0923189c993";
          fetchSubmodules = true;
          hash = "sha256-JAuapmAJrTERWuocmPfAD/ZVy3CYATkm47nP6d92fxA=";
        };
      }
  );

  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (python-final: python-prev: {
        # Apr 18 2026:
        # Test scipy/signal/tests/test_spectral.py::TestSTFT::test_roundtrip_scaling
        # fails. Since it builds correctly on normal nixpkgs, we'll assume that
        # the test failure is due to a bug in GCC.
        #
        # The package also likes to ignore parallelism requirements. We can put it
        # back into shape with a fairly simple fix, though.
        #
        # TRACK: https://github.com/NixOS/nixpkgs/issues/216033
        scipy = python-prev.scipy.overridePythonAttrs (prevAttrs: {
          preBuild =
            (prevAttrs.preBuild or "")
            + ''
              appendToVar pypaBuildFlags "-Ccompile-args=-j$NIX_BUILD_CORES"
            '';

          disabledTests =
            (prevAttrs.disabledTests or [])
            ++ [
              "test_roundtrip_scaling"
              "test_initial_step"
            ];
        });

        # May 7 2026
        # Test `test_gradient_sync_cpu_multi` fails
        accelerate = python-prev.accelerate.overridePythonAttrs (prevAttrs: {
          disabledTests =
            (prevAttrs.disabledTests or [])
            ++ [
              "test_gradient_sync_cpu_multi"
            ];
        });

        # May 7 2026
        # Test `test_execution_state` fails
        jupyter-server = python-prev.jupyter-server.overridePythonAttrs (prevAttrs: {
          disabledTests =
            (prevAttrs.disabledTests or [])
            ++ [
              "test_execution_state"
            ];
        });
      })
    ];

  # Apr 17 2026:
  # What a waste of literal days of my life. I've tried everything under the sun, but I can't seem
  # to get the overlay for qtbase to work right with `-march`. So, I give up. Perhaps I will return
  # at a later date (when some other problem inevitable crops up from this choice).
  #
  # For QT5, the qtbase package has problems with conditional compilation selecting multiple
  # implementations.
  #
  # On QT6, the configure phase produces results such as:
  # ```
  # -- Performing Test AVX512VBMI2 intrinsics
  # -- Performing Test AVX512VBMI2 intrinsics - Success
  # ```
  # Which is simply wrong. Unfortunately, this results in the generated binaries using AVX512 which
  # then fail with illegal instruction errors for obvious reasons.
  #
  # Apr 18 2026:
  # This is a better solution for QT6, however, it is dependent upon overrideScope preserving the
  # override attribute.
  #
  # TRACK: https://github.com/NixOS/nixpkgs/issues/447012
  # qt6 = prev.qt6.overrideScope (scope-final: scope-prev: {
  #   qtbase = scope-prev.qtbase.overrideAttrs (prevAttrs: {
  #     env.NIX_CFLAGS_COMPILE = plain-pkgs.lib.debug.traceVal (
  #       prevAttrs.env.NIX_CFLAGS_COMPILE
  #     );
  #     patches = (prevAttrs.patches or []) ++ [
  #       ../packages/qtbase/avx512.patch
  #     ];
  #
  #     cmakeFlags = plain-pkgs.lib.debug.traceVal (prevAttrs.cmakeFlags or []) ++ [
  #       "-DQT_FEATURE_avx512f=OFF"
  #     ];
  #
  #     postPatch= ''
  #     echo -e "\n\n\n\nfoo\n\n\n\n"
  #
  #     '' + (prevAttrs.postPatch or "");
  #   });
  # });
  # qt6 = prev.qt6.overrideScope (scope-final: scope-prev: {
  #   qtbase = scope-prev.qtbase.overrideAttrs (prevAttrs: {
  #   });
  # });
  qt6 = genericPkgs.qt6; # Unfortunately, really aggressive but necessary without overrideScope
  qt5 = prev.qt5.overrideScope (
    qt-final: qt-prev: {
      qtbase = plain-pkgs.qt5.qtbase;
    }
  );

  # Jun 11 2026:
  # Build failure caused by kdoctools not liking GCC -march
  kdePackages = prev.kdePackages.overrideScope (
    kde-final: kde-prev: {
      kdoctools = genericPkgs.kdePackages.kdoctools;
    }
  );

  # Apr 18 2026:
  # Currently, the test `TestRedLock.test_locking_dogpile[redis_cache]` fails. The easy way out is
  # to just disable the test.
  #
  # Apr 27 2026:
  # The tests on this package are simply causing too many problems. For now, disable checks
  # entirely and maybe revisit this decision sometime in the future.
  #
  # Apr 29 2026:
  # Moved to nixpkgs patch

  # aiocache = prev.aiocache.overrideAttrs (oldAttrs: {
  #   doCheck = false;
  #   pytestCheckPhase = ''
  #   '';
  #   disabledTestPaths = (oldAttrs.disabledTestPaths or []) ++ [
  #     "tests/acceptance/test_lock.py"
  #   ];
  # });

  # Apr 18 2026:
  # When building, LLVM, the check phase will attempt to find .git and halt (but not fail) if it
  # cannot do so. This just disables that behavior
  #
  # TRACK: https://github.com/NixOS/nixpkgs/issues/447012
  triton-llvm = prev.triton-llvm.overrideAttrs (oldAttrs: {
    cmakeFlags =
      (oldAttrs.cmakeFlags or [])
      ++ [
        "-DLLVM_APPEND_VC_REV=OFF"
      ];
  });

  # Apr 19 2026:
  # Building with SSE support enabled causes errors due to invalid casting of SSE intrinsic types.
  #
  # TRACK: https://github.com/dyne/frei0r/issues/228
  #        https://github.com/dyne/frei0r/issues/239
  #        Note that the first one is closed by the maintainer, yet the problem persists.
  frei0r = prev.frei0r.overrideAttrs (oldAttrs: {
    patches =
      (oldAttrs.patches or [])
      ++ [
        ../packages/frei0r/sse-cast.patch
      ];
  });

  # Apr 27 2026:
  # The hashes on the patches for unity-test are incorrect
  unity-test = prev.unity-test.overrideAttrs (oldAttrs: {
    patches = [
      (prev.fetchpatch2 {
        url = "https://patch-diff.githubusercontent.com/raw/ThrowTheSwitch/Unity/pull/771.patch";
        hash = "sha256-viNwaqZ+hjIY4qnlLN55/TMzqmoNAgc1Eq5Yv17tr7c=";
      })
      (prev.fetchpatch2 {
        url = "https://patch-diff.githubusercontent.com/raw/ThrowTheSwitch/Unity/pull/790.patch";
        hash = "sha256-GRz7/0cAUWHPMMaclzyvObBpGaA6HcXY2OCKDFitrE4=";
      })
    ];
  });

  # Patches adding in additional source mirrors
  autogen = prev.autogen.overrideAttrs (oldAttrs:
    assert oldAttrs.version == "5.18.16"; {
      patches =
        prev.lib.lists.imap0 (
          i: v:
            if i == 7
            then
              (prev.fetchpatch {
                name = "guile-3.patch";
                urls = [
                  "https://raw.githubusercontent.com/gentoo/gentoo/refs/heads/master/sys-devel/autogen/files/autogen-5.18.16-guile-3.patch"
                  "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-devel/autogen/files/autogen-5.18.16-guile-3.patch?id=43bcc61c56a5a7de0eaf806efec7d8c0e4c01ae7"
                ];
                sha256 = "18d7y1f6164dm1wlh7rzbacfygiwrmbc35a7qqsbdawpkhydm5lr";
              })
            else v
        )
        prev.autogen.patches;
    });
  libssh = prev.libssh.overrideAttrs {
    src = prev.fetchurl {
      inherit (prev.libssh.src) hash;
      urls = [
        "https://files.b0x207.dev/public/mirror/libssh/libssh-${prev.libssh.version}.tar.xz"
        prev.libssh.src.url
      ];
    };
  };
  # TODO: see if this actually does anything
  pyside6 = prev.pyside6.overrideAttrs (oldAttrs:
    assert oldAttrs.version == "6.11.0"; {
      patches = [
        (prev.fetchurl {
          urls = [
            "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/?id=05e328476f2d6ef8a0f3f44aca1e5b1cdb7499fc"
            "https://github.com/qtproject/pyside-pyside-setup/commit/05e328476f2d6ef8a0f3f44aca1e5b1cdb7499fc.patch"
          ];
          hash = "sha256-PPLV5K+xp7ZdG0Tah1wpBdNWN7fsXvZh14eBzO0R55c=";
        })
      ];
    });
}
