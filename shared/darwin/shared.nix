{ pkgs, ... }: {

  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    hubble
    inter
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
        rev = "f9acdc967fd6d72baf29cd2b30078ef8742676f6";
        sha256 = "sha256-4Rmt6LV/sDvhb3Zc90ZCtcJwbNIvEf2e7oxQMZrTeY8=";
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
    plugins = [
      pkgs.tmuxPlugins.gruvbox
    ];
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

