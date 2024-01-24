{ nixpkgs-unstable, system }:

self: super: {

  poetry_stable = super.poetry;

  poetry = nixpkgs-unstable.legacyPackages.${system}.poetry;

  kiwitalk = nixpkgs-unstable.legacyPackages.${system}.kiwitalk;

  signal-desktop_stable = super.signal-desktop;

  signal-desktop = nixpkgs-unstable.legacyPackages.${system}.signal-desktop;

}
