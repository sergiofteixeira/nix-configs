{
  pkgs,
  lib,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
in

{
  #age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
  home.username = "steixeira";

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    signing = {
      key = "~/.ssh/github_signing.pub";
      signByDefault = true;
      format = "ssh";
    };
    settings = {
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
      user = {
        email = "sergio@tiko.org";
        name = "Sergio Teixeira";
      };
      alias = {
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
      };
      color.ui = true;
      github.user = "sergiofteixeira";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      gpg.format = "ssh";
    };
  };

  home.file = {
    #".config/ghostty/config" = {
    #source = ./configs/ghostty/config;
    #};
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
    nodejs_24
    terraform-ls
    terraform-docs
    go
    gopls
    gofumpt
    golangci-lint
    tree-sitter
    nixfmt
    uv
    typescript-go

    # devops
    kubectx
    awscli2
    kubectl
    kubebuilder
    kubetail
    kubernetes-helm
    redis
    eks-node-viewer
    gh
    gnused

    # utils
    watch
    neovim
    ripgrep
    jq
    fzf
    fd
    wget
    curl
    zip
    xz
    unzip
    htop
    gnumake
    nix-prefetch-scripts
    nh

    # misc
    file
    which
    tree
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
    settings = pkgs.lib.importTOML ./configs/starship/starship.toml;
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
    functions = {
      envsource = ''
        for line in (cat $argv | grep -v '^#')
            set item (string split -m 1 '=' $line)
            set -gx $item[1] $item[2]
            echo "Exported key $item[1]"
        end
      '';
    };
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
      gcm = "git commit --signoff";
      ghpr = "gh pr create --web";
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
    plugins = [ ];
    shortcut = "l";
    secureSocket = false;
    shell = "${pkgs.fish}/bin/fish";

    extraConfig = ''
      unbind C-b
      set -g prefix C-t
      set -ga terminal-overrides ",*256col*:Tc"
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
