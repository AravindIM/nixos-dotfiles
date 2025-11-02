{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi-wayland
  ];

  # This assumes you keep both files in your Home Manager config directory
  # e.g., ~/.config/nixpkgs/rofi/config.rasi and gruvbox-dark.rasi

  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/gruvbox-dark.rasi".source = ./gruvbox-dark.rasi;

  # optional: set environment variables if rofi needs them
  home.sessionVariables = {
    ROFI_CONFIG_FILE = "${config.xdg.configHome}/rofi/config.rasi";
  };
}
