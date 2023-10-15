{ pkgs, ... }:
with builtins;
with pkgs.lib;
{
  nixpkgs.overlays = [ ../.. ];
  
  nixpkgs.config = {
    allowUnfreePredicate =
      pkg: elem (getName pkg)
        [ "vscode-extension-ms-vsliveshare-vsliveshare"
          "vscode-with-extensions"
          "vscode"
        ];
    
    permittedInsecurePackages = [ ];
  };
}
