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
    ./services.nix
  ];

  virtualisation = {
    virtualbox.host.enable = false;
    virtualbox.host.enableExtensionPack = true;
  };

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  zramSwap.enable = true;

  system.stateVersion = stateVersion;

}

