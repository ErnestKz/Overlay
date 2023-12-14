{ pkgs, ... }:
{
  programs.light.enable = true;
  services.xserver.displayManager =
    { sx.enable = true;
    };
}

