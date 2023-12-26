{ nixpkgs-unstable, system }:

self: super: {

  poetry_stable = super.poetry;

  poetry = nixpkgs-unstable.legacyPackages.${system}.poetry;

}
