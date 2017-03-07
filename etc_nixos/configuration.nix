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
      "acpi_osi="
    ];
    extraModprobeConfig = '''';
    extraModulePackages = with pkgs.linuxPackages; [ acpi_call ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = super: {
     # alsaLib = super.alsaLib.overrideDerivation (attrs:{
      #  configureFlags = "--disable-aload";
     # }); 
      bluez5_28 = super.bluez5_28.overrideDerivation (attrs:{
        buildInputs = attrs.buildInputs ++ [
          super.pythonPackages.dbus-python
        ];
      });
      bluez4 = super.callPackage <nixpkgs/pkgs/os-specific/linux/bluez/default.nix> {
        pythonPackages = super.pythonPackages // {
          dbus = super.pythonPackages.dbus-python;
        };
      };
    };
  };
 
  programs = {
    mosh.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
    cpu.intel.updateMicrocode = true;
    pulseaudio = {
      enable = false; #true;
      package = pkgs.pulseaudioFull;
      extraConfig = '''';
    };
  };
 
  sound = {
    enable = true;
    enableMediaKeys = true;
    extraConfig = " ";
  };

  networking = {
    hostName = "x230-nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      22000 # syncthing
      24800 # synergy-server
    ]; 
  };

  environment.systemPackages = with pkgs; [
    wget git vim tmux acpitool rxvt_unicode-with-plugins dillo
  ];

  fonts = {
    enableCoreFonts = true;
    fonts = with pkgs; [ baekmuk-ttf ubuntu_font_family ];
    fontconfig = {
      dpi = 128;
      ultimate.allowBitmaps = false;
      hinting.style = "slight";
      defaultFonts = {
        monospace = [ 
          "DejaVu Sans Mono"
          "Baekmuk Gulim"
        ];
        serif = [ 
          "DejaVu Serif"
          "Baekmuk Batang"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Baekmuk Gulim"
        ];
      };
    };
  };

  systemd.services.synergy-client.serviceConfig.User="jhhuh";
  systemd.services.synergy-server.serviceConfig.User="jhhuh";
  environment.etc."synergy-server.conf".text = ''
    section: screens
      x230-nixos:
      macth68.cern.ch:
    end

    section: links
      x230-nixos:
        right = macth68.cern.ch
      macth68.cern.ch:
        left = x230-nixos
    end
  '';

  services = {
    thinkfan = {
      enable = true;
      sensor = "/sys/devices/virtual/hwmon/hwmon0/temp1_input";
    };
    synergy = {
      client = {
        enable = true;
        serverAddress = "192.168.2.1";
        autoStart = false;
      };
      server = {
        enable = true;
        autoStart = false;
      };
    };
    tor = {
      enable = true;
      client.enable = true;
    };
    thermald.enable = true;
    syncthing = {
      enable = true;
      user = "jhhuh";
      dataDir = "/home/jhhuh/.config/syncthing";
    };
    tlp.enable = true;
    acpid.enable = true;
    openssh = {
      enable = true;
      forwardX11 = true;
      extraConfig = ''
        Ciphers blowfish-cbc
      '';
    };
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "ctrl:swapcaps";
      libinput.enable = false;
      synaptics = {
        enable = false;
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
    extraGroups = [ "wheel" "networkmanager" "lp" "audio" ];
    isNormalUser = true;
    uid = 1000;
  };

  system.stateVersion = "16.09";

  time.timeZone = "Europe/Paris";

  nix = {
    buildCores = 8;
  };

  services.printing = {
    enable = true;
#    drivers = [ pkgs.hplip ];
  };

  virtualisation = {
    xen = {
      enable = true;  
#      domain0MemorySize = 2048;
    };
  };
  
}
