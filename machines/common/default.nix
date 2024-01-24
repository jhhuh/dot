{ config, pkgs, modulesPath, ... }:
{

  imports = [
    (import ./nix.nix)
    (import ./users.nix)
    (import ./distributed-build.nix)
    (import ./nix-ld.nix)
    (import ./virtualisation.nix)
    (import ./tailscale.nix)
    (import ./allow-unfree.nix)
    (import ./pam.nix)
  ];

  programs.slock.enable = true;

  services.udev.packages = with pkgs; [ vial ];

  environment.systemPackages = [ pkgs.cntr ];

}
