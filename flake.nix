{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    probe-rs-rules = {
      url = "github:jneem/probe-rs-rules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      pkgs = import nixpkgs { inherit system; };
      system = "x86_64-linux";
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;
      nixosConfigurations = {
        work = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
          };
          modules = [
            ./hosts/work/configuration.nix
            {
              networking.hostName = "mark-workstation";
            }
          ];
        };

        elitebook = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
          };
          modules = [
            ./hosts/elitebook/configuration.nix
            {
              networking.hostName = "mark-elitebook";
            }
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/laptop/configuration.nix
          ];
        };
      };
    };
}
