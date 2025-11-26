{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      general = {
        import = [ "${config.xdg.configHome}/alacritty/gruvbox_dark.toml" ];
      };

      font = {
        normal = {
          family = "Departure Mono NerdFont";
          style = "Regular";
        };
        size = 14;
      };
    };
  };

  # Link local file into ~/.config/alacritty/
  xdg.configFile."alacritty/gruvbox_dark.toml".source = ./gruvbox_dark.toml;
}
