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
      options = [ "noatime" "commit=60" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DC65-18FB";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/0aa72326-86f6-4f09-bc34-9c770e892e1d";
      fsType = "ext4";
      options = [ "noatime" "commit=60" ];
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
}
