{ config, pkgs, modulesPath, ... }:
{

  imports = [
    (import ./nix.nix)
    (import ./users.nix)
    (import ./distributed-build.nix)
    (import ./nix-ld.nix)
    (import ./virtualisation.nix)
  ];

  programs.slock.enable = true;

  environment.systemPackages = [ pkgs.cntr ];

}
