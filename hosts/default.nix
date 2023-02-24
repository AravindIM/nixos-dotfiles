{ lib, inputs, system, home-manager, user, nix-doom-emacs,... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nix-doom-emacs;};
    modules = [
      ./thinkpad/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user nix-doom-emacs;};
        home-manager.users.${user} = {
          imports = [
            ./thinkpad/home.nix
            ../modules/user-configs/neovim.nix
            ../modules/user-configs/sway.nix
            nix-doom-emacs.hmModule
            ../modules/user-configs/doom-emacs.nix
          ];
        };
      }
    ];
  };
}
