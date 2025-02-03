{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    unstable = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
      config.allowUnfree = true;
    };
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs =
    {
      nixpkgs,
      zen-browser,
      unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
    };
}
