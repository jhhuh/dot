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

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  zramSwap.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = stateVersion;

}

