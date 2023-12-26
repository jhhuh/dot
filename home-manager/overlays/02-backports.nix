{ nixpkgs-unstable, system }:

self: super: {

  poetry_stable = super.poetry;

  poetry = nixpkgs-unstable.legacyPackages.${system}.poetry;

  signal-desktop_stable = super.signal-desktop;

  signal-desktop = nixpkgs-unstable.legacyPackages.${system}.signal-desktop;

}
