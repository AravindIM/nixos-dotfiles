{ lib, inputs, system, home-manager, user, doom-emacs,... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs doom-emacs;};
    modules = [
      ./thinkpad/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user doom-emacs;};
        home-manager.users.${user} = {
          imports = [
            ./thinkpad/home.nix
            ../modules/desktop/sway/home.nix
            doom-emacs.hmModule
          ] ++ (import ../modules/shell)
          ++ (import ../modules/editor);
        };
      }
    ] ++ [(import ../modules/desktop/sway)];
  };
}
