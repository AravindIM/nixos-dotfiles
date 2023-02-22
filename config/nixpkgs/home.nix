{ config, pkgs, ...}:
let
  theme = {
    background = "#000000";
    foreground = "#ffffff";
  
    black = "#000000";
    red = "#ff8059";
    green = "#44bc44";
    yellow = "#d0bc00";
    blue = "#2fafff";
    magenta = "#feacd0";
    cyan = "#00d3d0";
    white = "#bfbfbf";
  
    bright-black = "#595959";
    bright-red = "#ef8b50";
    bright-green = "#70b900";
    bright-yellow = "#c0c530";
    bright-blue = "#79a8ff";
    bright-magenta = "#b6a0ff";
    bright-cyan = "#6ae4b9";
    bright-white = "#ffffff";
  };
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = ./doom.d;  # Directory containing your config.el, init.el
                                # and packages.el files
  };
in
{
  home.username = "aim";
  home.homeDirectory = "/home/aim";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    fira-code
    font-awesome
    wl-clipboard
    rename
    htop
    git
    neofetch
    gcc
    foot
    waybar
    wofi
    sxiv
    wlogout
    pywal
    sway-contrib.grimshot
    doom-emacs
    vlc
    zathura
    gimp
    xournal
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = false;
    withPython3 = true;
    extraConfig = ''
        let g:coc_data_home = $HOME . '/.config/coc'
        set expandtab
        set tabstop=4
        set shiftwidth=4
      '';
    coc.enable = true;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier
      nixpkgs-fmt
      terraform
    ];
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lastplace
      vim-markdown
      markdown-preview-nvim
      nvim-jdtls
      coc-nvim
      coc-css
      coc-explorer
      coc-git
      coc-go
      coc-html
      coc-json
      coc-prettier
      coc-pyright
      coc-yaml
      copilot-vim
      vim-surround
    ];
  };

  services.mpris-proxy.enable = true;

  home.file.".config/foot" = {
    source = ./config/foot;
    recursive = true;
  };

  home.file.".config/waybar" = {
    source = ./config/waybar;
    recursive = true;
  };

  home.file.".config/wofi" = {
    source = ./config/wofi;
    recursive = true;
  };

  home.file.".config/wal" = {
    source = ./config/wal;
    recursive = true;
  };

  home.file.".config/zathura" = {
    source = ./config/zathura;
    recursive = true;
  };

  wayland.windowManager.sway = let
    gsettings = "${pkgs.glib}/bin/gsettings";
    gnomeSchema = "org.gnome.desktop.interface";
    importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
      config="/home/alternateved/.config/gtk-3.0/settings.ini"
      if [ ! -f "$config" ]; then exit 1; fi
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      ${gsettings} set ${gnomeSchema} gtk-theme "$gtk_theme"
      ${gsettings} set ${gnomeSchema} icon-theme "$icon_theme"
      ${gsettings} set ${gnomeSchema} cursor-theme "$cursor_theme"
      ${gsettings} set ${gnomeSchema} font-name "$font_name"
    '';
    lockCommand = "swaylock -f -c 000000 -e -L -l --clock --indicator-idle-visible --effect-blur 12x4 -i $(cat /home/aim/.cache/wal/wal)";
  in
  {
    enable = true;
    xwayland = true;
    systemdIntegration = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    config = rec {
      modifier = "Mod4";

      input = {
        "type:touchpad" = {
          # tap = "enabled";
          dwt = "enabled";
          scroll_method = "two_finger";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
        };
        "type:pointer" = {
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "us";
        };
      };

      output = {
        "*".bg = "$(cat /home/aim/.cache/wal/wal) fill";
        "*".scale = "1";
      };

      # fonts = {
      #   names = [ "Rec Mono Casual" ];
      #   size = 10.5;
      # };

      focus = { followMouse = "always"; };

      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      window = {
        border = 2;
        titlebar = false;
        commands = [
          {
            criteria = { title = "^(.*) Indicator"; };
            command = "floating enable";
          }
          {
            criteria = { class = "Emacs"; };
            command = "opacity 0.9";
          }
        ];
      };

      startup = [
        { command = "${importGsettings}"; }
        { command = "bluetoothctl power off"; }
        { command = "${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources"; }
        {
          always = true;
          command = ''
            exec swayidle -w \
            timeout 300 '${lockCommand}' \
            timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
            before-sleep '${lockCommand}' '';
        }
      ];


      colors = rec {
        background = theme.background;
        unfocused = {
          text = theme.foreground;
          border = theme.foreground;
          background = theme.background;
          childBorder = theme.background;
          indicator = theme.foreground;
        };
        focusedInactive = unfocused;
        urgent = unfocused // {
          text = theme.foreground;
          border = theme.red;
          childBorder = theme.red;
        };
        focused = unfocused // {
          childBorder = theme.foreground;
          border = theme.foreground;
          background = theme.foreground;
          text = theme.background;
        };
      };

      bars = [{
       command = "waybar";
      }];

      modes = {
        resize = {
          h = "resize shrink width 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          Left = "resize shrink width 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      terminal = "foot";
      menu = "wofi";

      keybindings =
        let
          screenshot_dir =
            "~/Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png";
        in
        {
          "${modifier}+Shift+Return" = "exec foot";
          "${modifier}+Shift+c" = "kill";
          "${modifier}+Shift+r" = "reload";

          "${modifier}+p" = "exec ${menu} --show=drun -p 'Search'";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+Control+Left" = "resize shrink width 20 px";
          "${modifier}+Control+Down" = "resize grow height 20 px";
          "${modifier}+Control+Up" = "resize shrink height 20 px";
          "${modifier}+Control+Right" = "resize grow width 20 px";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Control+h" = "resize shrink width 20 px";
          "${modifier}+Control+j" = "resize grow height 20 px";
          "${modifier}+Control+k" = "resize shrink height 20 px";
          "${modifier}+Control+l" = "resize grow width 20 px";

          "${modifier}+Shift+Tab" = "workspace prev";
          "${modifier}+Tab" = "workspace next";

          "${modifier}+b" = "split v";
          "${modifier}+v" = "split h";

          "${modifier}+Shift+f" = "fullscreen toggle";

          "${modifier}+a" = "focus parent";
          "${modifier}+d" = "focus child";
          "${modifier}+Shift+n" = "focus next";
          "${modifier}+Shift+p" = "focus prev";

          "${modifier}+q" = "layout stacking";
          "${modifier}+t" = "layout tabbed";
          "${modifier}+s" = "layout toggle split";

          "${modifier}+f" = "floating toggle";
          "${modifier}+Control+s" = "sticky toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+Shift+b" = "bar mode toggle";

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

          "${modifier}+grave" = "workspace back_and_forth";

          "${modifier}+Shift+z" = "mark z; move scratchpad";
          "${modifier}+z" = "[con_mark=z] scratchpad show";
          "${modifier}+Shift+s" = "mode scratchpad";
          "${modifier}+r" = "mode resize";
          "${modifier}+y" = "mode workspace";

          "${modifier}+Alt+a" = "exec emacs";
          "${modifier}+Control+a" = "exec emacsclient -a '' -c";
          "${modifier}+Alt+b" = "exec firefox";

          "${modifier}+Shift+q" = "exit";
          "${modifier}+F1" = "exec bash ~/.nixos-config/config/scripts/man";
          "${modifier}+F2" = "exec bash ~/.nixos-config/config/scripts/websearch";
          "${modifier}+F3" =
            "exec echo $(sxiv -t -o ~/Pictures/Wallpapers) | xargs wal -i";

          "Print" =
            "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save screen ${screenshot_dir}";
          "${modifier}+Shift+Insert" =
            "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";

          "Control+Shift+space" = "exec makoctl dismiss -a";
          "Control+Shift+comma" = "exec makoctl restore";

          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 10";
          "XF86AudioLowerVolume+Shift" =
            "exec ${pkgs.pamixer}/bin/pamixer -d 10 --allow-boost";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 10";
          "XF86AudioRaiseVolume+Shift" =
            "exec ${pkgs.pamixer}/bin/pamixer -i 10 --allow-boost";
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";

          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
        };
    };
  }; 

  programs.bash = {
    enable = true;
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      wal -Reqn
    '';
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "22.11";
}

