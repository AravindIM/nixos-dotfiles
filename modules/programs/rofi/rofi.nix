{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

  # This assumes you keep both files in your Home Manager config directory
  # e.g., ~/.config/nixpkgs/rofi/config.rasi and gruvbox-dark.rasi

  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/gruvbox-dark.rasi".source = ./gruvbox-dark.rasi;
}
