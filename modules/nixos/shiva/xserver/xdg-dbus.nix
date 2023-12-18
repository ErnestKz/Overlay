{ ... }:
{ services.xserver =
    { updateDbusEnvironment = true;
      desktopManager.runXdgAutostartIfNone = true;
    };
}
