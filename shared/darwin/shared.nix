{ pkgs, ... }: {

  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    p7zip
    gotools
    gofumpt
    terraform-docs
    pre-commit
    sops
    hubble
    inter
    roboto-mono
    go-font
    meslo-lg
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
    ruff
    yq
    python311
    python311Packages.pip
    python311Packages.virtualenv
    python311Packages.pydantic
    poetry
    redis
    gh
    pulumi
    eks-node-viewer
    hadolint
    bun
    kube-bench
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };

  home.file = {
    ".config/fish/theme.fish" = {
      source = ../../additional-files/fish/theme.fish;
    };
    ".config/ghostty/config" = {
      source = ../../additional-files/ghostty/config;
    };
    ".config/nvim" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "sergiofteixeira";
        repo = "nvim";
        rev = "005bfd7a4c9822eff14c5b5bb3a2c28a20256ad4";
        sha256 = "sha256-IPaU4x1i1zXX746IPOQCoP4PPpNTSLCLhQ/80KXhn0I=";
      };
    };
  };

  programs.fzf.enable = true;
  programs.direnv.enable = true;
  programs.fzf.enableFishIntegration = true;

  programs.eza.enable = true;

  programs.git = {
    enable = true;
    userName = "Sergio Teixeira";
    userEmail = "sergiofpteixeira@gmail.com";
    signing = {
      key = "/Users/steixeira/.ssh/id_ed25519";
      signByDefault = true;
    };
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
      gpg.format = "ssh";
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "l";
    secureSocket = false;

    extraConfig = ''
      unbind C-b
      set-option -g default-shell /run/current-system/sw/bin/fish
      set -g prefix C-t
      set -ga terminal-overrides ",*256col*:Tc"
      bind -n C-k send-keys "clear"\; send-keys "Enter"
      bind _ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      set -g mouse on
      set-option -sg escape-time 10
      set-option -g history-limit 50000
      set-window-option -g mode-keys vi
      set -g set-clipboard on
      bind -n C-n next-window
      set-option -g status-left-length 200
      set-option -g status-left " #{session_name}  "
      set-option -g status-right "#(date '+%I:%M %p') "
      set-option -g status-style "bg=default" # gruvbox dark
      set-option -g window-status-format "#{window_index}:#{window_name}#{window_flags} " # window_name -> pane_current_command
      set-option -g window-status-current-format "#{window_index}:#{window_name}#{window_flags} "
      set-option -g window-status-current-style "fg=#e1a345"  #for gruvbox use: dcc7a0 or aeb6ff
      set-option -g window-status-last-style "fg=#936a2e"
      set-option -g window-status-activity-style none
      set -g status-justify left
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

  programs.zoxide = { enable = true; };

  programs.bash.enable = true;
  programs.fish = {
    enable = true;
    shellInit = ''
      direnv hook fish | source
      if test -e ~/.config/fish/theme.fish
        source ~/.config/fish/theme.fish
      end
    '';
    shellAliases = {
      loginprod = "aws sso login --profile prod";
      logindev = "aws sso login --profile dev";
      ls = "ls --color=auto -F";
      workswitch = "darwin-rebuild switch --flake ~/nix-configs/.#m1work";
      homeswitch = "darwin-rebuild switch --flake ~/nix-configs/.#m1pro";
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
