# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./services.nix
    ];
  
  nixpkgs.config.allowUnfree = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

#  boot.loader.grub.device = "/dev/sda";

#  systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  
  # networking
  networking = {
    hostName = "nixos-mbp";
    firewall.allowedUDPPortRanges = [
      { from = 60000; to = 61000; }
    ];
  };
  
  # i18n
  i18n = {
    consoleFont = "latarcyrheb-sun32";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  }; 
  
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      ubuntu_font_family
      baekmuk-ttf
    ];
  };

  # time zone
  time.timeZone = "Europe/Amsterdam";

  # packages
  environment.systemPackages = with pkgs; [
     wget vim git tmux gnumake bash
     mosh
     glusterfs
  ];

  # user account
  users.extraUsers.jhhuh = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ];
   };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}
