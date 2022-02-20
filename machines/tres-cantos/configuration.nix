# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "tres-cantos";
  networking.networkmanager.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      bash-prompt-suffix = \[\033[1;33m\]\n(nix devlop)\$ \[\033[0m\]
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "@wheel" ];
  };

  console.font = "latarcyrheb-sun32";
  console.useXkbConfig = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "kime";
      kime.config = {
        indicator.icon_color = "White";
      };
    };
  };

  programs = {
    singularity.enable = true;
    ssh.startAgent = true;
    slock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nixos-option
    pciutils hdparm powertop htop
    acpitool
    wget git vim tmux
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      roboto-mono
      baekmuk-ttf source-han-sans-korean
      ubuntu_font_family
      #google-fonts
      #noto-fonts
      noto-fonts-cjk
      #noto-fonts-emoji
      #terminus_font_ttf
      #inconsolata
      #source-code-pro
      #ttf_bitstream_vera
      #open-dyslexic
      #source-code-pro
    ];
  };

  hardware.pulseaudio.enable = true;

  security.wrappers = {
    ipfs = let
      cfg = config.services.ipfs;
    in {
      setuid = true;
      permissions = "u+rx,g+x";
      owner = cfg.user;
      group = cfg.group;
      source = "${cfg.package}/bin/ipfs";
    };
  };

  services = {
    redis.servers = {
      "cryptostore".enable = true;
      "cryptostore".bind = "127.0.0.1";
      "cryptostore".port = 6379;
    };

    tailscale.enable = true;

    ipfs = {
      enable = true;
      autoMount = true;
      extraConfig = {
        Addresses = {
          NoAnnounce = [
            "/ip4/10.0.0.0/ipcidr/8"
            #"/ip4/100.64.0.0/ipcidr/10"
            "/ip4/169.254.0.0/ipcidr/16"
            "/ip4/172.16.0.0/ipcidr/12"
            "/ip4/192.0.0.0/ipcidr/24"
            "/ip4/192.0.2.0/ipcidr/24"
            "/ip4/192.168.0.0/ipcidr/16"
            "/ip4/198.18.0.0/ipcidr/15"
            "/ip4/198.51.100.0/ipcidr/24"
            "/ip4/203.0.113.0/ipcidr/24"
            "/ip4/240.0.0.0/ipcidr/4"
            "/ip6/100::/ipcidr/64"
            "/ip6/2001:2::/ipcidr/48"
            "/ip6/2001:db8::/ipcidr/32"
            "/ip6/fc00::/ipcidr/7"
            "/ip6/fe80::/ipcidr/10"
          ];
        };
        Swarm = {
          AddrFilters = [
            "/ip4/10.0.0.0/ipcidr/8"
            #"/ip4/100.64.0.0/ipcidr/10"
            "/ip4/169.254.0.0/ipcidr/16"
            "/ip4/172.16.0.0/ipcidr/12"
            "/ip4/192.0.0.0/ipcidr/24"
            "/ip4/192.0.2.0/ipcidr/24"
            "/ip4/192.168.0.0/ipcidr/16"
            "/ip4/198.18.0.0/ipcidr/15"
            "/ip4/198.51.100.0/ipcidr/24"
            "/ip4/203.0.113.0/ipcidr/24"
            "/ip4/240.0.0.0/ipcidr/4"
            "/ip6/100::/ipcidr/64"
            "/ip6/2001:2::/ipcidr/48"
            "/ip6/2001:db8::/ipcidr/32"
            "/ip6/fc00::/ipcidr/7"
            "/ip6/fe80::/ipcidr/10"
          ];
        };
      };
    };

     xserver = {
       enable = true;
       xkbOptions = "ctrl:swapcaps";
       displayManager.sessionCommands = ''
         ${pkgs.xlibs.xset}/bin/xset r rate 250 50
       '';
       #autoRepeatDelay = 250;
       #autoRepeatInterval = 20;
       desktopManager = {
         gnome.enable = true;
       };
     };

    openssh = {
      enable = true;
      forwardX11 = true;
      gatewayPorts = "yes";
    };

  };

  security.pam.enableSSHAgentAuth = true;

  users.users."jhhuh" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "ipfs" ];
    uid = 1000;
  };

  system.stateVersion = "22.05";
  time.timeZone = "Asia/Seoul";
}
