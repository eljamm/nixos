[
  (final: prev: {
    swt = prev.swt.overrideAttrs (oldAttrs: {
      env.NIX_CFLAGS_COMPILE = toString [
        "-Wno-error=deprecated-declarations"
      ];
    });
  })
]
