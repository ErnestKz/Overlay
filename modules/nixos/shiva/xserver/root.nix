{ ek, ... }:
{ services.xserver.enable = true;
  imports =
    [ ek.modules.nixos.shiva.xserver.touchpad
      ek.modules.nixos.shiva.xserver.display-manager
      ek.modules.nixos.shiva.xserver.xdg-dbus
      ek.modules.nixos.shiva.xserver.video-drivers
    ];
}
