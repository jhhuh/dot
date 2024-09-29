{ nixpkgs-unstable, system }:

self: super: {
  nixpkgs-channels = {
    unstable = nixpkgs-unstable.legacyPackages.${system};
  };
}
