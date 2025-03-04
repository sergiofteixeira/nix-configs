{
  pkgs,
  lib,
  config,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
in

{
  #age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
  home.username = "steixeira";

  fonts.fontconfig.enable = true;

  programs.chromium =
    if isLinux then
      {
        enable = true;
        commandLineArgs = [ "--force-device-scale-factor=2 --force-dark-mode" ];
      }
    else
      { enable = false; };

  programs.kitty =
    if isLinux then
      {
        enable = true;
        extraConfig = builtins.readFile ./configs/kitty/kitty.conf;
      }
    else
      { enable = false; };

  programs.git = {
    enable = true;
    userName = "Sergio Teixeira";
    userEmail = "sergiofpteixeira@gmail.com";
    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
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

  home.file = {
    ".config/i3/config" = lib.mkIf (isLinux) { source = ./configs/i3/config; };
    ".config/fish/theme.fish" = {
      source = ./configs/fish/theme.fish;
    };
    ".config/ghostty/config" = {
      source = ./configs/ghostty/config;
    };
    #".config/nvim" = {
    #recursive = true;
    #source = pkgs.fetchFromGitHub {
    #owner = "sergiofteixeira";
    #repo = "nvim";
    #rev = "dbf09413303729271d29209940baa6ed325b09fc";
    #sha256 = "sha256-Algoqw+al338lUfhPSPpxQ63vYEDzo5WwmKGxr8UhH4=";
    #};
    #};
  };

  home.packages = with pkgs; [

    # languages
    nodejs_20
    pnpm
    terragrunt
    terraform-ls
    deno
    terraform-docs
    sops
    go
    gopls
    gotools
    gofumpt
    rustc
    gcc
    cargo
    tree-sitter
    nixfmt-rfc-style
    pipenv
    pyenv
    poetry
    nil
    ruff-lsp
    nodePackages.live-server
    uv
    zig
    evil-helix

    # devops
    sshs
    kubectx
    awscli2
    kubectl
    kubetail
    kubernetes-helm
    kube-bench
    redis
    eks-node-viewer
    gh
    deploy-rs
    nh
    trivy
    gnused
    opentofu
    minikube
    tilt
    stern

    # utils
    watch
    neovim
    ripgrep
    jq
    yq-go
    eza
    fzf
    fd
    wget
    curl
    pre-commit
    neofetch
    zip
    xz
    unzip
    htop
    gnumake
    nix-prefetch-scripts
    argo
    rainfrog

    # misc
    file
    which
    tree
    nix-prefetch-scripts

    # fonts
    meslo-lgs-nf
    meslo-lg
    go-font
    inter
    geist-font
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less";
    CLICLOLOR = 1;
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.fzf.enableFishIntegration = true;

  programs.starship = {
    enableZshIntegration = true;
    enableFishIntegration = true;
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      python.disabled = true;
      helm.disabled = true;
      lua.disabled = true;
      package.disabled = true;
      terraform = {
        style = "#7CCDFD";
      };
      golang.disabled = true;
      directory = {
        style = "#89DDFF";
      };
      git_branch = {
        style = "#76946A";
      };
      kubernetes = {
        disabled = false;
        style = "#C792EA";
      };
      line_break.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
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

  programs.fish = {
    enable = true;
    shellInit = ''
      if test -e ~/.config/fish/theme.fish
        source ~/.config/fish/theme.fish
      end
      set -Ux PYENV_ROOT $HOME/.pyenv
      fish_add_path $PYENV_ROOT/bin
      pyenv init - | source
    '';
    shellAliases = {
      loginprod = "aws sso login --profile prod";
      logindev = "aws sso login --profile dev";
      ls = "ls --color=auto -F";
      phrikeswitch = "sudo nixos-rebuild switch  --flake .#phrike";
      workswitch = "darwin-rebuild switch --flake ~/nix-configs/.#m1work";
      homeswitch = "darwin-rebuild switch --flake ~/nix-configs/.#m1pro";
      vim = "nvim";
      vi = "nvim";
      k = "kubectl";
      kx = "kubectx";
      po = "kubectl get pod";
      gc = "git checkout";
      gs = "git status";
      terraform = "tofu";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      k = "kubectl";
      vim = "nvim";
      vi = "nvim";
      kx = "kubectx";
      po = "kubectl get pod";
      gs = "git status";
      gc = "git checkout";
      ".." = "cd ..";
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    plugins = [ ];
    shortcut = "l";
    secureSocket = false;
    shell = "${pkgs.fish}/bin/fish";

    extraConfig = ''
      unbind C-b
      set -g prefix C-t
      set -ga terminal-overrides ",*256col*:Tc"
      bind -n C-k send-keys "clear"; send-keys "Enter"
      bind _ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      set -g mouse on
      set-option -sg escape-time 10
      set-option -g history-limit 50000
      set-window-option -g mode-keys vi
      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour137
      set -g status-left ' '
      set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 20
      setw -g window-status-current-format '#[fg=colour250]#I#[fg=colour255]:#W#[fg=colour50]#F'
      setw -g window-status-format '#[fg=colour237]#I#[fg=colour250]:#W#[fg=colour244]#F'
      set -g set-clipboard on
      bind -n C-n next-window
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
    '';
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
