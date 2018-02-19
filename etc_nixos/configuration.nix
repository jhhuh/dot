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

    blacklistedKernelModules = [
#      "e1000e"
      "dvb_usb_rtl28xxu"
    ];
    
    kernelParams = [
      "acpi_osi="
      "acpi_backlight=none"
      "thinkpad_acpi.brightness_enable=0"
      "i915.enable_rc6=1" "i915.enable_fbc=1" "i915.semaphores=1"
      "drm.debug=0xe"
      "zswap.enabled=1"
    ];

#    kernelPackages = pkgs.linuxPackages_latest;
   
    extraModulePackages = with pkgs.linuxPackages; [ acpi_call ];
  
    kernel = {
      sysctl = {
        "nmi_watchdog" = false;
        "vm.dirty_ratio" = 30;
        "vm.dirty_writeback_centisecs" = 1500;
        "vm.dirty_expire_centisecs" = 4500;
        "vm.swappiness" = 20;
        "vm.laptop_mode" = 5;
      };
    };

    extraModprobeConfig = ''
    '';
 
  };

  powerManagement = {
    enable = true;
    powerDownCommands = "${pkgs.kmod}/bin/modprobe -r iwlwifi";
    resumeCommands = "${pkgs.kmod}/bin/modprobe iwlwifi";
  };

  i18n = {

    consoleColors = [
      "002b36" "dc322f" "859900" "b58900"
      "268bd2" "d33682" "2aa198" "eee8d5"
      "002b36" "cb4b16" "586e75" "657b83"
      "839496" "6c71c4" "93a1a1" "fdf6e3"
    ];
#
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ hangul ];
    };

  };

  nixpkgs.config = {
    allowUnfree = true;
#    packageOverrides = super: {
#      haskellPackages = super.haskell.packages.ghc802.override {
#        overrides = self: super:
#          with pkgs.haskell.lib; {
#          # https://github.com/NixOS/nixpkgs/issues/31411
#          c2hs = (overrideCabal super.c2hs {
#                   version = "0.26.2-28-g8b79823";
#                   doCheck = false;
#                   src = pkgs.fetchFromGitHub {
#                     owner = "deech";
#                     repo = "c2hs";
#                     rev = "8b79823c32e234c161baec67fdf7907952ca62b8";
#                     sha256 = "0hyrcyssclkdfcw2kgcark8jl869snwnbrhr9k0a9sbpk72wp7nz";
#                 };}).override { language-c = self.language-c_0_7_0; };
#        };
#      };
#    };
  };

  programs = {
#    adb.enable = true;
    ssh = {
      startAgent = true;
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
    bluetooth.enable = false;
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
    cpu.intel.updateMicrocode = true;
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };
  };
 
  sound = {
    enable = true;
    mediaKeys.enable = true;
    enableOSSEmulation = true;
    extraConfig = ''
      pcm.dmix_PCH = {
        type dmix
        ipc_key = 1024
        slave.pcm = "hw:PCH,0"
      }
      pcm.dmix_III = {
        type dmix
        ipc_key = 2048 
        slave.pcm = "hw:III,0"
      }
      pcm.quad = {
        type multi
        slaves.a.pcm dmix_PCH 
        slaves.a.channels 2
        slaves.b.pcm dmix_III 
        slaves.b.channels 2
        bindings.0 { slave a; channel 0; }
        bindings.1 { slave a; channel 1; }
        bindings.2 { slave b; channel 0; }
        bindings.3 { slave b; channel 1; }
      }
      pcm.stereo2quad {
        type route
        slave.pcm "quad"
        ttable.0.0 1
        ttable.1.1 1
        ttable.0.2 1
        ttable.1.3 1
      }
#      pcm.!default {
#        type asym
#        playback.pcm "plug:stereo2quad"
#        capture.pcm "plug:dsnoop:hw:PCH,0"
#      }
    '';
  };

  networking = {
    hostName = "x230-nixos";
    networkmanager = {
      enable = true;
    };
    firewall.allowedTCPPorts = [ 8000 5901 ];
    #extraHosts =
    #  let someonewhocares_hosts = pkgs.fetchurl rec {
    #      name = "hosts";
    #      url = with meta; "https://github.com/${owner}/${repo}/blob/${rev}/data/someonewhocares.org/hosts?raw=true";
    #      sha256 = "03k0dkzvmwg3g06w01a039gdgba9gxci4bi1440bfkd1g52j0f02";
    #      meta = {
    #        owner = "StevenBlack";
    #        repo = "hosts";
    #        rev = "37e211d2115ad528c8be3d43e255fdf9b3b6c486";
    #      };
    #  };
    #  in builtins.readFile someonewhocares_hosts;
  };
 
  environment.systemPackages = with pkgs; [
    pciutils hdparm powertop htop 
    networkmanager
    acpitool # system management utils
    btrfs-progs parted cryptsetup # disk utils
    wget git vimNox tmux # basic applications
    xcalib
    rxvt_unicode-with-plugins dillo # gui applications
#    google-chrome # heavier applications
    haskellPackages.xmobar
    (emacs.override { withGTK3 = false; })
  ];
 
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    fonts = with pkgs; [
      roboto-mono
      baekmuk-ttf source-han-sans-korean
      ubuntu_font_family
      google-fonts
      noto-fonts-cjk
      terminus_font_ttf
      inconsolata
      source-code-pro
      ttf_bitstream_vera
      open-dyslexic
    ];
    fontconfig = {
      dpi = 108;
      hinting = {
        enable = true;
        autohint = false;
#        style = "medium";
      };
      defaultFonts = {
        monospace = [ "Ubuntu Mono" "DejaVu Sans Mono" "Baekmuk Gulim" ];
        serif     = [ "DejaVu Serif" "Baekmuk Batang" ];
        sansSerif = [ "DejaVu Sans" "Baekmuk Gulim" ];
      };
    };
  };
 
#  systemd.services.synergy-client.serviceConfig.User="jhhuh";
#  systemd.services.synergy-server.serviceConfig.User="jhhuh";
#  environment.etc = {
#    "synergy-server.conf".text = ''
#      section: screens
#        x230-nixos:
#        macth68.cern.ch:
#      end
#  
#      section: links
#        x230-nixos:
#          right = macth68.cern.ch
#        macth68.cern.ch:
#          left = x230-nixos
#      end
#   '';
#  };

  environment.etc = let upower = config.services.upower.package; in {
    "UPower/UPower.conf" = {
       source = "${config.services.upower.package}/etc/UPower/UPower.conf";
    };
  };

  services = {
     ipfs = {
       enable = false;
       autoMount = true;
     };
 
     glusterfs.enable = false;

#     resolved = {
#       enable = true;
#       fallbackDns = [ "8.8.8.8" ];
#     };
 
#    redshift = {
#      enable = true;
#      provider = "geoclue2";
#    };
#
#    postfix = {
#      enable = true;
#      config = { inet_protocols = "ipv4"; };
#    };

    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
 
    udev.packages = [ pkgs.rtl-sdr ];
 
    upower.enable = true;
    mpd = {
      enable = true;
      group = "audio";
#      extraConfig = ''
#        audio_output {
#          type "alsa"
#          name "my ALSA device"
#          device "hw:1"
#        }
#      '';
    };
#    actkbd = {
#      enable = true;
#      bindings = [ 
#        { keys = [ 113 ]; events = [ "key" ];
#          command = "${pkgs.alsaUtils}/bin/amixer -q -c0 set Master toggle"; }
#        { keys = [ 114 ]; events = [ "key" "rep" ];
#          command = "${pkgs.alsaUtils}/bin/amixer -q -c0 set Master 5%- unmute"; }
#        { keys = [ 115 ]; events = [ "key" "rep" ];
#          command = "${pkgs.alsaUtils}/bin/amixer -q -c0 set Master 5%+ unmute"; }
#        { keys = [ 190 ]; events = [ "key" ];
#          command = "${pkgs.alsaUtils}/bin/amixer -q -c0 set Capture toggle"; }
#      ];
#    };

#    emacs = {
#      enable = true;
#      package = pkgs.emacs25;
#    };

#    thinkfan = {
#      enable = true;
#      sensor = "/sys/devices/virtual/hwmon/hwmon0/temp1_input";
#      #sensor = "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input";
#    };
#
#    thermald.enable = true;
#
#    tlp.enable = true;

    tor = {
      enable = true;
      client.enable = true;
    };

    openssh = {
      enable = true;
      forwardX11 = true;
    };

    xserver = {
      enable = true;
      exportConfiguration = true;
      videoDrivers = [ "intel" ];
      deviceSection = ''
        Option "AccelMethod" "sna"
      '';
      layout = "us";
      xkbOptions = "caps:ctrl_modifier,shift:both_capslock";
      windowManager = {
        default = "xmonad";
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          haskellPackages = pkgs.haskellPackages;
        };
      };
      displayManager = {
        sddm.enable = false;
        sessionCommands = let
          x230_icc = pkgs.fetchurl rec {
              name = "lp125wf2-spb2.icc";
              url = with meta; "https://github.com/${owner}/${repo}/blob/${rev}/${name}?raw=true";
              sha256 = "18lidz1k98344i5z6m7mf8sl12syzvrzrlpbjm7hmhhyv96a44rc";
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
          '';
      };
    };
  };
  
  users.extraUsers."jhhuh" = {
    extraGroups = [ "wheel" "networkmanager" "audio" "adbusers" "vboxusers" ];
    isNormalUser = true;
    uid = 1000;
  };
 
  system.stateVersion = "17.09";
 
  time.timeZone = "Asia/Seoul";
 
  nix = {
#    buildMachines = [
#      { hostName = "deephy";
#        sshUser = "jhhuh";
#        sshKey= "/root/.ssh/id_dsa";
#        system = "x86_64-linux";
#        maxJobs = 4;
#      }
#    ];
    distributedBuilds = false;
    buildCores = 0;
    trustedBinaryCaches = [ "https://nixcache.reflex-frp.org" "https://cache.dmj.io" ];
    binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
  };

  virtualisation = {
    xen = {
      enable = false;
      bootParams = [ "iommu=verbose" ];
    };
    virtualbox.host = {
      enable = true;
    };

  };
# 
}
 
