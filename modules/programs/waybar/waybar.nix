{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 3;
        tray = { spacing = 3; };
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "idle_inhibitor" "pulseaudio" "cpu" "memory"
          "temperature" "backlight" "battery" "clock"
          "tray" "custom/power"
        ];
      };
    };

    # Use a separate CSS file (linked via .source)
    style = "@import \"${config.xdg.configHome}/waybar/style.css\";";
  };

  # Link the CSS files from your nix flake dir
  home.file.".config/waybar/style.css".source =
    ./style.css;

  home.file.".config/waybar/gruvbox-dark.css".source =
    ./gruvbox-dark.css;
}
