{ config, pkgs, ... }:

{
  home.username = "steixeira";
  home.homeDirectory = "/home/steixeira";

  programs.git = {
    enable = true;
    userName = "Sergio Teixeira";
    userEmail = "sergiofpteixeira@gmail.com";
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      github.user = "sergiofteixeira";
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [
    # languages
    nodejs
    nodePackages.typescript
    terraform
    terraform-ls
    kubectl
    kubectx
    helm
    go
    rustc
    cargo
    tree-sitter
    python311
    python311Packages.pip
    nixfmt
    htop

    neofetch
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    exa # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fd
    wget
    curl

    # misc
    file
    which
    tree
    gnupg
    btop  # replacement of htop/nmon

    lm_sensors # for `sensors` command
  ];

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    shellAliases = {
      k = "kubectl";
      vim = "nvim";
      vi = "nvim";
      kx = "kubectx";
      po = "kubectl get pod";
    };
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
