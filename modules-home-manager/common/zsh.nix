{ pkgs, ... }:
{
  home.sessionVariables =
    { SHELL = "zsh"; };
  programs.zsh =
    { enable = true;
      history.size = 10000;
      oh-my-zsh =
        { enable = true;
          plugins = [ "git"];
          theme = "robbyrussell";
        };
    
      initExtra = "source ${toString ./zsh-vterm-compat.zsh}";
    };
}
