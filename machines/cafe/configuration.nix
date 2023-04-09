{ config, lib, pkgs, stateVersion, ... }:

{

  networking.hostName = "cafe";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [ 8444 ];

  time.timeZone = "Asia/Seoul";

  imports = [
    ./hardware-configuration.nix
    ./desktop.nix
    ./tailscale.nix
    ./services.nix
  ];

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  # see https://github.com/balsoft/nixos-fhs-compat
  # environment.fhs.enable = true;
  # environment.fhs.linkLibs = true;
  # environment.lsb.enable = true;
  # environment.lsb.support32Bit = true;

  programs.nix-ld.enable = true;

  zramSwap.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = stateVersion;

}

