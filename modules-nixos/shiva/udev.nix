{ pkgs, ... }:
with { inherit (pkgs) runCommand writeShellScript; } ;
with { inherit (pkgs.xorg) xkbcomp xset; } ;
let
  kinesis-idVendor = "29ea" ;
  layout-laptop =
    runCommand
      "keyboard-layout" { }
      "${xkbcomp}/bin/xkbcomp ${./ek/layout-laptop.xkb} $out"
  ;
  layout-kinesis =
    runCommand
      "keyboard-layout" { }
      "${xkbcomp}/bin/xkbcomp ${./ek/layout-kinesis.xkb} $out"
  ;
  activate-kb = layout: (writeShellScript "activate-kb.sh"
    ''${xkbcomp}/bin/xkbcomp ${layout} $DISPLAY
	    ${xset}/bin/xset r rate 200 30'')
  ;
in
{
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="${kinesis-idVendor}", ACTION=="add", RUN+="${activate-kb layout-kinesis}"
    SUBSYSTEM=="input", ATTRS{idVendor}=="${kinesis-idVendor}", ACTION=="remove", RUN+="${activate-kb layout-laptop}"
  '';
}
  # Bus 003 Device 007: ID 29ea:0102 Kinesis Corporation Advantage2 Keyboard
  # UDEV  [1254.013948] remove   /devices/pci0000:00/0000:00:14.0/usb3/3-7/3-7:1.2/0003:29EA:0102.0005 (hid)
