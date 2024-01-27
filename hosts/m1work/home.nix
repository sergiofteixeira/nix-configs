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
    ruby
    ruff
    yq
    python311
    python311Packages.requests
    poetry
    redis
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };

  home.file = {
    ".config/fish/theme.fish" = {
      source = ../../fish_files/theme.fish;
    };
    ".config/ghostty/config" = {
      text = ''
        font-family = Liga SFMono Nerd Font
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
        theme = kanagawabones
      '';
      executable = false;
    };
    ".config/nvim" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "sergiofteixeira";
        repo = "nvim";
        rev = "a567c82d5531349fa0e1396ce2d4418007f6116e";
        sha256 = "sha256-Ntk/ezyzwG56TIdE07pvGbhz/Yswb3pDEjB70mUPQZE=";
      };
    };
  };

  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";

  programs.fzf.enable = true;
  programs.fzf.enableFishIntegration = true;

  programs.eza.enable = true;

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
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    shellAliases = {
      ls = "ls --color=auto -F";
      nixswitch = "darwin-rebuild switch --flake ~/nix-configs/.#m1work";
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
    shell = "${pkgs.fish}/bin/fish";
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
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.bash.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -l foreground DCD7BA normal
      set -l selection 2D4F67 brcyan
      set -l comment 727169 brblack
      set -l red C34043 red
      set -l orange FF9E64 brred
      set -l yellow C0A36E yellow
      set -l green 76946A green
      set -l purple 957FB8 magenta
      set -l cyan 7AA89F cyan
      set -l pink D27E99 brmagenta
      set -g fish_color_normal $foreground
      set -g fish_color_command $cyan
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment
    '';
    shellAliases = {
      loginprod = "aws sso login --profile prod";
      logindev = "aws sso login --profile dev";
      ls = "ls --color=auto -F";
      nixswitch = "darwin-rebuild switch --flake ~/nix-configs/.#m1work";
      vim = "nvim";
      vi = "nvim";
      k = "kubectl";
      kx = "kubectx";
      po = "kubectl get pod";
      gc = "git checkout";
      gs = "git status";
    };
  };

}
