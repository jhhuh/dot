# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

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
  networking.firewall.trustedInterfaces = ["tailscale0"];

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
      owner = "root";
      group = "ipfs";
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
      gatewayAddress = "/ip4/100.79.188.51/tcp/8080";
      swarmAddress = [
        "/ip4/100.79.188.51/tcp/4001"
        "/ip4/100.79.188.51/udp/4001/quic"
        #"/ip4/0.0.0.0/tcp/4001"
        "/ip6/::/tcp/4001"
        #"/ip4/0.0.0.0/udp/4001/quic"
        "/ip6/::/udp/4001/quic"
      ];

      extraConfig = {
        Datastore.StorageMax = "100GB";
        Addresses = {
          # The following three entries are necessary since otherwise they get overriden
          # because of poor implementation of NixOS's ipfs module
          API = config.services.ipfs.apiAddress;
          Gateway = config.services.ipfs.gatewayAddress;
          Swarm = config.services.ipfs.swarmAddress;
      
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
        Bootstrap = [
          "/ip4/100.86.154.86/tcp/4001/p2p/12D3KooWGuXnacqv2wUhXW7ozHbUCNJSvet3SvDAFuG2jGAgaisF"
        ];
        Experimental.FilestoreEnabled = true;
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

  systemd.services.ipfs.preStart = with lib;
    mkForce (
      let
        cfg = config.services.ipfs;
        profile =
          if cfg.localDiscovery
          then "local-discovery"
          else "server";
      in ''
        if [[ ! -f "$IPFS_PATH/config" ]]; then
          ${cfg.package}/bin/ipfs init ${optionalString cfg.emptyRepo "-e"} --profile=${profile}
        else
          # After an unclean shutdown this file may exist which will cause the config command to attempt to talk to the daemon. This will hang forever if systemd is holding our sockets open.
          rm -vf "$IPFS_PATH/api"
        
          ${cfg.package}/bin/ipfs --offline config profile apply ${profile}
        fi
      '' + optionalString cfg.autoMount ''
        ${cfg.package}/bin/ipfs --offline config Mounts.FuseAllowOther --json true
        ${cfg.package}/bin/ipfs --offline config Mounts.IPFS ${cfg.ipfsMountDir}
        ${cfg.package}/bin/ipfs --offline config Mounts.IPNS ${cfg.ipnsMountDir}
      '' + optionalString cfg.autoMigrate ''
        ${pkgs.ipfs-migrator}/bin/fs-repo-migrations -y
      '' + concatStringsSep "\n" (collect
          isString
          (mapAttrsRecursive
            (path: value:
              # Using heredoc below so that the value is never improperly quoted
              ''
                read value <<EOF
                ${builtins.toJSON value}
                EOF
                ${cfg.package}/bin/ipfs --offline config --json "${concatStringsSep "." path}" "$value"
              '')
            ({
              Addresses.API = cfg.apiAddress;
              Addresses.Gateway = cfg.gatewayAddress;
              Addresses.Swarm = cfg.swarmAddress;
            } //
            cfg.extraConfig)))
      );

  security.pam.enableSSHAgentAuth = true;

  users.users."jhhuh" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "ipfs" ];
    uid = 1000;
  };

  system.stateVersion = "22.05";
  time.timeZone = "Asia/Seoul";
}
