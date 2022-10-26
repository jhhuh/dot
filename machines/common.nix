{ config, pkgs, modulesPath, ... }:
{
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
      experimental-features = nix-command flakes

      bash-prompt-suffix = \[\033[1;33m\]\n(nix develop)\$ \[\033[0m\]
    '';

    trustedUsers = [ "@wheel" ];

    settings = {
      substituters = [
        "http://mimir.coati-bebop.ts.net:5555"
      ];
      trusted-public-keys = [
        "cache.mimir.asgard-labs.com-1:lw8GZNUYWsCV6letxzfdeF+qmXpgBIEnjoAUWOCBA5w="
      ];
    };

    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "mimir.coati-bebop.ts.net";
        system = "x86_64-linux";
        sshUser = "builder";
        sshKey = "/root/.ssh/id_ed25519";
        maxJobs = 30;
        speedFactor = 10;
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUdDbXFITlVmOFd4OGd5blk4MzJBZTc2QjNuWFhOS2RvZ2N5L2c4SkZDRWMgcm9vdEBtaW1pcgo=";
      }
    ];
  };

  users.users."jhhuh" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "vboxusers"
      "wheel"
      "networkmanager"
      "libvirtd"
      "ipfs"
      "disk" ];
    uid = 1000;
  };

}
