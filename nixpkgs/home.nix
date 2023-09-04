programs.zsh = {
    enable = true;
     ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" "ripgrep" "zsh-autosuggestions" "zsh-syntax-highlighting"
        "autojump" 
      ];
      theme = "robbyrussell";
    };
  };

users.defaultUserSHell = pkgs.zsh; 
