{ lib, inputs, system, home-manager, user, hyprland, ... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs hyprland;};
    modules = [
      hyprland.nixosModules.default
      ./thinkpad/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user hyprland;};
        home-manager.users.${user} = {
          imports = [
            ./thinkpad/home.nix
            ../modules/desktop/hyprland/home.nix
            ../modules/theme/gruvbox.nix
            ../modules/programs/gnupg/gnupg.nix
          ] ++ (import ../modules/shell)
          ++ (import ../modules/editor);
        };
      }
    ] ++ [(import ../modules/desktop/hyprland)];
  };
}
