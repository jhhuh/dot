# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4b4fb48a-fb5f-46c3-8181-c157e0f61127";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."luksRoot".device = "/dev/disk/by-uuid/d0976092-4a8f-4edc-abb7-f1e0d61cfe80";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4b4fb48a-fb5f-46c3-8181-c157e0f61127";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  boot.initrd.luks.devices."luksRoot".device = "/dev/disk/by-uuid/d0976092-4a8f-4edc-abb7-f1e0d61cfe80";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A548-44C3";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/9eac2d71-a6af-410d-9623-b9e7172d0617"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
}
