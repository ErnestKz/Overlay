{ ... }:
{
  services.xserver.enable = true;
  imports =
    [ ./touchpad.nix
      ./display-manager.nix
      ./xdg-dbus.nix
      ./video-drivers.nix
    ];
}
