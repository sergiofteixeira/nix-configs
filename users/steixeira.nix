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

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./configs/kitty/kitty.conf;
  };

  home.file.".config/nvim".recursive = true;
  home.file.".config/nvim".source = pkgs.fetchFromGitHub {
    owner = "sergiofteixeira";
    repo = "nvim";
    rev = "b5daf5de3dae4625a04b156ad3fdf8771cc29a31";
    sha256 = "sha256-Z3DqYg5ICopOZFOcKz3Prx4JtYuowx9EG0AoKa8kr2Y=";
  };

  home.packages = with pkgs; [
    # languages
    nodejs
    nodePackages.typescript
    terraform
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

    neofetch
    zip
    xz
    unzip
    p7zip
    magic-wormhole

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

    lm_sensors # for `sensors` command
    vimPlugins.packer-nvim

    # fonts
    meslo-lgs-nf
    meslo-lg
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

  programs.starship = {
    enableZshIntegration = true;
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


  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod1";
      terminal = "kitty";
      fonts = {
        names = [ "Liberation Mono" ];
        style = "Regular";
        size = 11.0;
      };
      output = {
        "Virtual-1" = {
          mode = "1600x1200";

        };
      };
      bars = [
        {
          fonts = {
            names = [ "Liberation Mono" ];
            style = "Regular";
            size = 11.0;
          };
          position = "bottom";
          statusCommand = "i3status";
        }
      ];
      keybindings = {
        #Launch stuff
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+b" = "exec firefox";
        "${modifier}+Shift+Return" = "exec fuzzel";
        "${modifier}+d" = "exec wofi --show run";

        # Windows
        "${modifier}+q" = "kill";

        # Layouts
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";

        # Switch the current container between different layout styles
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+f" = "fullscreen";

        # Toggle the current focus between tiling and floating mode
        "${modifier}+Shift+space" = "floating toggle";

        # Swap focus between the tiling area and the floating area
        "${modifier}+space" = "focus mode_toggle";

        # Move focus to the parent container
        "${modifier}+a" = "focus parent";

        # Workspaces
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        # Resize
        "${modifier}+r" = "mode resize";

        # Other keybindings
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
      };
      modes = {
        resize = {
          "Down" = "resize grow height 10 px";
          "Escape" = "mode default";
          "Left" = "resize shrink width 10 px";
          "Return" = "mode default";
          "Right" = "resize grow width 10 px";
          "Up" = "resize shrink height 10 px";
          "h" = "resize shrink width 10 px";
          "j" = "resize grow height 10 px";
          "k" = "resize shrink height 10 px";
          "l" = "resize grow width 10 px";
        };
      };
    };
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
