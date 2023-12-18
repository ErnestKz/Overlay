{ ... }:
{ sound.enable = true;
  hardware.pulseaudio =
    { enable = true;
      extraConfig = "unload-module module-suspend-on-idle";
    };
}
