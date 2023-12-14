{ pkgs, ek, ... }:
let
  inherit (pkgs) runCommand ;
  inherit (pkgs.xorg) xkbcomp xset;
  
  layout-kinesis = ek.scripts."layout-kinesis.xkb";
  layout-laptop = ek.scripts."layout-laptop.xkb";
    
  xkbcomp-run = xkb-file:
    let
      compiled-command =
        runCommand "keyboard-layout" { }
          "${xkbcomp}/bin/xkbcomp ${xkb-file} $out";
    in "${xkbcomp}/bin/xkbcomp ${compiled-command} $DISPLAY";
in
{
  home.file.".profile".text = "sx ./.xsession";
  
  xsession =
    { enable = true;
      windowManager.command = "ssh-agent ${ek.xmonad}/bin/xmonad";
      initExtra = ''
        if [ -e /dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd ]; then
          ${xkbcomp-run layout-kinesis}
        else
          ${xkbcomp-run layout-laptop}
        fi
        ${xset}/bin/xset r rate 200 30'';
    };
}
