{ pkgs, ... }:
{
  home.packages = with pkgs;
    [ chromium
      minmacs

      xorg.xkbcomp
      htop

      zsh
      ripgrep
      binutils
      file
      zip
      unzip
      wget
      flameshot

      pavucontrol
      # pulseaudio
      pamixer
      alsa-utils
      gcc

      python3

      gimp
      pinta
      lazpaint
      xfce.thunar
      
      obs-studio
    ];
}
