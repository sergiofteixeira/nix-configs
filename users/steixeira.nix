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

  home.file.".config/nvim".recursive = true;
  home.file.".config/nvim".source = pkgs.fetchFromGitHub {
    owner = "sergiofteixeira";
    repo = "nvim";
    rev = "67ad49cf4f072d0e5a9a8b4a2d90b29d9e3e1c83";
    sha256 = "sha256-aZUFFY99aGWot/ok36JZgdEotW10HB34XKhV+04QN48=";
  };

  home.packages = with pkgs; [
    # languages
    nodejs
    nodePackages.typescript
    terraform
    terraform-ls
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

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

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
      export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
    '';

    shellAliases = {
      k = "kubectl";
      vim = "nvim";
      vi = "nvim";
      kx = "kubectx";
      po = "kubectl get pod";
      gs = "git status";
      gc = "git checkout";
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "l";
    secureSocket = false;

    extraConfig = ''
      unbind C-b
      set -g prefix C-t
      set -ga terminal-overrides ",*256col*:Tc"
      bind -n C-k send-keys "clear"\; send-keys "Enter"
    '';
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
