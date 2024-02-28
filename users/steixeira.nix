{ pkgs, ... }:

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

  programs.chromium = {
    enable = true;
    commandLineArgs = [ "--force-device-scale-factor=2" ];
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./configs/kitty/kitty.conf;
  };

  home.file = {
    ".config/fish/theme.fish" = {
      source = ../additional-files/fish/theme.fish;
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

  xsession.pointerCursor = {
    name = "macOS-BigSur";
    package = pkgs.apple-cursor;
    size = 48;
  };

  home.packages = with pkgs; [
    lxappearance
    i3status
    # languages
    _1password-gui
    nodejs
    terraform-ls
    kubectx
    awscli2
    kubectl
    pulumi-bin
    kubernetes-helm
    go
    rustc
    cargo
    tree-sitter
    nixfmt
    nixpkgs-fmt
    htop
    gnumake
    python311
    python311Packages.flake8
    poetry
    ruff-lsp
    ruff

    neofetch
    zip
    xz
    unzip
    p7zip
    magic-wormhole
    firefox

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fd
    wget
    curl

    # misc
    file
    which
    tree
    gnupg
    btop # replacement of htop/nmon
    nix-prefetch-scripts
    slack
    redshift

    lm_sensors # for `sensors` command
    vimPlugins.packer-nvim

    # fonts
    meslo-lgs-nf
    meslo-lg
    go-font
    nil
    xfce.thunar
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
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
      line_break.disabled = true;
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

  programs.fish = {
    enable = true;
    shellInit = ''
      if test -e ~/.config/fish/theme.fish
        source ~/.config/fish/theme.fish
      end
    '';
    shellAliases = {
      loginprod = "aws sso login --profile prod";
      logindev = "aws sso login --profile dev";
      ls = "ls --color=auto -F";
      heliosswitch = "sudo nixos-rebuild switch  --flake .#helios";
      vim = "nvim";
      vi = "nvim";
      k = "kubectl";
      kx = "kubectx";
      po = "kubectl get pod";
      gc = "git checkout";
      gs = "git status";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi
    '';

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


  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
