{ ... }:
{ users.users.ek = {
    isNormalUser = true;
    initialPassword = "";
    extraGroups =
      [ "wheel"
	      "networkmanager"
        "audio"
        "video"
      ];
  };
}
