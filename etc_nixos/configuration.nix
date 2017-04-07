# vim: expandtab:autoindent:softtabstop=2:shiftwidth=2

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    ./my-hardware-configuration.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    blacklistedKernelModules = [ "e1000e" ];
    kernelParams = [
      "acpi_osi="
      "acpi_backlight=none"
      "thinkpad_acpi.brightness_enable=0"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
      "i915.enable_rc6=7"
      "nmi_watchdog=0"
      "vm.dirty_writeback_centisecs=6000"
      "vm.laptop_mode=5"
#      "iwlwifi.power_save=Y"
#      "iwlwifi.power_level=1"
    ];
    extraModprobeConfig = '''';
    extraModulePackages = with pkgs.linuxPackages; [ acpi_call ];
  };

  i18n = {
    consoleColors = [
      "002b36" "dc322f" "859900" "b58900"
      "268bd2" "d33682" "2aa198" "eee8d5"
      "002b36" "cb4b16" "586e75" "657b83"
      "839496" "6c71c4" "93a1a1" "fdf6e3"
    ];
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ hangul ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = super: rec {
      bluez4 = let
          pkgsPath = /nix/var/nix/profiles/per-user/root/channels/nixos/pkgs;
        in
          super.callPackage (pkgsPath+"/os-specific/linux/bluez") {
            pythonPackages = super.pythonPackages //
              { dbus = super.pythonPackages.dbus-python; };
          };
    };
  };

  programs = {
    ssh = {
      extraConfig = ''
        Host deephy
            Hostname 216.218.134.74
            Port 22221
      '';
      knownHosts = [
        { hostNames = [ "deephy" "[216.218.134.74]:22221" ];
          publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCovh25nDcUaO/PHK+Y/1A2Da3eb4Y7kMVotBb8VHl0TNJKtmI3hX/IbxEJ/kNDzowP0umhXS/94AtZ8U8heZWmo95cPx42ccDveJe8vdjpA+X9R6k4p3kb7DosQUYkvfzgM2/Aqvknonq4+Z5wOmJJopsQ2AqTIr/kd+L+OcXIV1D3gw+AYIbjTo6NjQhfLIbIIRlIjZEJZjqFGr/SO//clTJtLy5XEnkdXcb5zJmCGul3eXg3plB7IvifBjPc7Ja5jnMB8cO0aP2IqyX11mC8V/mmQBEOBeJ+PsP1spYQu2Y90WBdrPEdox4WF2sw+VB9IMeMqdJST22ntnVDPcEE+FIu9kOfRr9CS4QJuKGd8RYVkM5HNMqOqh23euWXx046wCuKMdYg9kNBNowgFdnEDqZv3/NT08ixMvMclEiGzxIRuBMEoLyyLQnqFdzQUWbUxhSxBeLw0/lONJMyfhGxiSYCEXp3Bn9dT+w/NSjByoLwyTOcHZW/ceaw7AcVIdp8e1S1YelMKaNMq5pXdzVRi+L/tAJwpuaxKWpGu82rIUgW9ViLb/ub5k+Sr7wSYNw1hXm4BhJXIrS3/gBkd4YQtHbxu4DOVWXYLPI0h1/Ep8dXo6SSUuXmE/OL1E7G6A8ZYLiX+kct3eiI6w3mrt06COQxc5qRdoU+9cga2K16Fw==";
        }
      ];
    };
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
      enable = true;
      package = pkgs.pulseaudioFull;
#      extraConfig = '''';
    };
  };
 
  sound = {
    enable = true;
    enableMediaKeys = true;
    enableOSSEmulation = false;
#    extraConfig = ''
#      pcm.dsp {
#        type plug
#        slave.pcm "dmix"
#      }
#    ''; 
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
    acpitool # system management utils
    btrfs-progs parted # disk utils
    wget git vim tmux # basic applications
    xcalib
    rxvt_unicode-with-plugins dillo i3lock i3status # gui applications
    firefox google-chrome # heavier applications
  ];
 
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      google-fonts
      baekmuk-ttf
      source-han-sans-korean
      ubuntu_font_family
    ];
    fontconfig = {
      dpi = 128;
      confPackages = [ pkgs.fontconfig-ultimate ];
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
  environment.etc = {
    "synergy-server.conf".text = ''
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
  };
 
  services = {
    emacs = {
      enable = true;
      package = pkgs.emacs25;
    };
    upower.enable = true;
    thinkfan = {
    enable = true;
    sensor = "/sys/devices/virtual/hwmon/hwmon0/temp1_input";
#      sensor = "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input";
    };
    synergy = {
      client = {
        enable = false;
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
      enable = false;
      user = "jhhuh";
      dataDir = "/home/jhhuh/.config/syncthing";
    };
    tlp.enable = true;
    openssh = {
      enable = true;
      forwardX11 = true;
      extraConfig = ''
        Ciphers blowfish-cbc
      '';
    };
    xserver = {
      enable = true;
      exportConfiguration = true;
      layout = "us";
      xkbOptions = "ctrl:swapcaps";
      desktopManager = {
        default = "kde5";
        kde5.enable = true;
      };
      windowManager = {
#        default = "i3";
        i3.enable = true;
      };
      displayManager = {
        sddm.enable = true;
        sessionCommands = let
          x230_icc = pkgs.fetchurl rec {
              name = "lp125wh2-slb3.icc";
              url = with meta; "https://github.com/${owner}/${repo}/blob/${rev}/${name}?raw=true";
              sha256 = "0kxvyywy2dk2c17571534jjx1cq0bf76zy7r0pcmri9mnc95njay";
              meta = {
                owner = "soleblaze";
                repo = "icc";
                rev = "77775bfdeb08a73ba74db6457610be2859b7ce6f";
              };
            };
          in
          ''
            /run/current-system/sw/bin/xinput --disable "SynPS/2 Synaptics TouchPad"
            /run/current-system/sw/bin/xcalib ${x230_icc} 
            DISPLAY=:0 /run/current-system/sw/bin/xset r rate 330 50
          '';
#        slim.enable = false;
#        lightdm.enable = true;
        xserverArgs = [
          "-ardelay 330"
          "-arinterval 20"
        ];
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
    buildMachines = [
      { hostName = "deephy";
        sshUser = "jhhuh";
        sshKey= "/root/.ssh/id_dsa";
        system = "x86_64-linux";
        maxJobs = 4;
      }
    ];
    distributedBuilds = false;
    buildCores = 0;
  };

  services.printing = {
    enable = true;
  };
 
  virtualisation = {
    xen = {
      enable = false;
    };
  };
 
}
 
