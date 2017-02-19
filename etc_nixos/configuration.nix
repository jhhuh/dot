# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    kernelParams = [
      "acpi_osi=!\"Windows 2012\""
    ];
    extraModprobeConfig = '''';
  };
  
  sound = {
    enable = true;
    enableMediaKeys = true;
  };

  networking = {
    hostName = "x230-nixos";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget git vim tmux acpitool rxvt_unicode-with-plugins dillo
  ];

  services = {
    tlp.enable = true;
    acpid.enable = true;
    openssh.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "ctrl:swapcaps";
      synaptics = {
        enable = true;
        additionalOptions = ''
          Option "VertResolution" "100"
          Option "HorizResolution" "65"
          Option "MinSpeed" "1"
          Option "MaxSpeed" "1"
          Option "AccelerationProfile" "2"
          Option "AdaptiveDeceleration" "16"
          Option "ConstantDeceleration" "16"
          Option "VelocityScale" "20"
          Option "AccelerationNumerator" "30"
          Option "AccelerationDenominator" "10"
          Option "AccelerationThreshold" "10"
          Option "TapButton2" "0"
          Option "HorizHysteresis" "100"
          Option "VertHysteresis" "100"
        '';
      };
      windowManager = {
	default = "i3";
        i3.enable = true;
      };
    };
  };
  
  users.extraUsers."jhhuh" = {
    extraGroups = [ "wheel" "networkmanager" ];
    isNormalUser = true;
    uid = 1000;
  };

  system.stateVersion = "16.09";
  
  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

}
