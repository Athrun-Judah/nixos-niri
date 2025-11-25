{
  description = "My custom nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri
    niri.url = "github:sodiboo/niri-flake";

    # Stylix
    stylix.url = "github:danth/stylix";

    # Chaotic Nyx (CachyOS kernel & Optimizations)
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = {self, nixpkgs, home-manager, niri, stylix, chaotic, ...}@inputs:
  let
  username = "player";
  host = "legion";
  system = "x86_64-linux";
  in {
    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs username host system;
        };
        modules = [
          ./hosts/${host}/default.nix

          chaotic.nixosModules.default
          stylix.nixosModules.stylix
          niri.nixosModules.niri

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;}
            home-manager.users.${username} = import ./home/default.nix;
          }
        ];
      };
    };
  };
}
