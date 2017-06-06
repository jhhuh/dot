{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci" "ehci_pci" "ahci"
        "sd_mod" "sdhci_pci"
      ];
      luks.devices."luks" = {
        device = "/dev/disk/by-uuid/444980a0-554b-4bd7-9962-95118aee0d9f";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/18df1976-52bb-4d66-81b6-b1abcf4572b1";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DC65-18FB";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/592751b4-ff1c-41af-b4c6-d365e83436ec";
      fsType = "btrfs";
      options = [ "noatime" "autodefrag" "commit=60" "compress=lzo" "space_cache" "subvol=@" "subvol=@home" ];
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
}
