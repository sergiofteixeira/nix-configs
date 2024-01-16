{ pkgs, ... }: {
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    docker
    docker-compose
    kubectl
    kubectx
    kubernetes-helm
    kubetail
    ripgrep
    fd
    jq
    curl
    less
    awscli2
    nixfmt
    watch
    #terraform
    terraform-ls
    rustup
    go
    tree-sitter
    htop
    unzip
    nix-prefetch-scripts
    go
    gopls
    neovim
    nodejs
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };

  home.file = {
    ".config/ghostty/config" = {
      text = ''
      font-size = 20
      font-feature = ss01
      font-feature = ss02
      font-feature = ss03
      font-feature = ss04
      font-feature = ss05
      font-feature = ss06
      font-feature = ss07
      font-feature = ss08
      font-feature = liga
      font-feature = dlig
      font-feature = calt

      adjust-cell-width = 0
      adjust-cell-height = 0

      clipboard-read = "allow"
      clipboard-paste-protection = false
      clipboard-trim-trailing-spaces = true
      theme = JetBrains Darcula
      '';
      executable = false;
    };
    ".config/nvim" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "sergiofteixeira";
        repo = "nvim";
        rev = "37ed205d17c646978d7704f134e42cc3015d3814";
        sha256 = "sha256-pYnTTqTyJ27v+xwMe4yA9WDk/a3v6I9jjLLHn2ft34E=";
      };
    };
  };

  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.exa.enable = true;

  programs.git = {
    enable = true;
    userName = "Sergio Teixeira";
    userEmail = "sergiofpteixeira@gmail.com";
    aliases = {
      prettylog =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      color.ui = true;
      github.user = "sergiofteixeira";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    shellAliases = {
      ls = "ls --color=auto -F";
      nixswitch = "darwin-rebuild switch --flake ~/nix-configs/.#m1pro";
      vim = "nvim";
      vi = "nvim";
      k = "kubectl";
      kx = "kubectx";
      po = "kubectl get pod";
      gc = "git checkout";
      gs = "git status";
    };

  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    plugins = [
      pkgs.tmuxPlugins.gruvbox
    ];
    shortcut = "l";
    secureSocket = false;

    extraConfig = ''
      unbind C-b
      set -g prefix C-t
      set -ga terminal-overrides ",*256col*:Tc"
      bind -n C-k send-keys "clear"\; send-keys "Enter"
      bind _ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      set -g mouse on
      set-option -sg escape-time 10
      set-option -g history-limit 50000
      set-window-option -g mode-keys vi
      set-option -g status-position bottom
      set -g set-clipboard on
      bind -n C-n next-window
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
  };

  programs.zoxide = {
    enable = true;
  };

}

