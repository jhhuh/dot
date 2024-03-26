{ ... }:

let

  jhhuh-pubkeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOp1CH+oR5hGNRXbxNQ19X0NbltZ+nGMc05qZPj+5dt jhhuh@aero15"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjHaMyKVhfex3wyWkZNQv288qnmy1oDTy/L7J+iht8N jhhuh@x230"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAION2oxUEENwK/lOSU+UdVGQyYkfOpfforL3AJ5BsO69k jhhuh@tres-cantos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGoftvY9HAKWXoL+I4GTOCRQnqRnpgbwaxXjpytAE6kP jhhuh@p1gen3"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIxr4HSvBYCDxAigSKGB2zghw/3RXNnBdQl5HdGCaVZS jhhuh@dasan"
  ];

  users-uid-map = {
    "jhhuh" = 1000;
  };

  ensure-int = i: assert (__isInt i); i;

  users-and-groups-with-UPG = { users, groups ? {} }@attrs: attrs // {

    users = __mapAttrs
      (name: value: value // { group = name; })
      users;

    # A poor man's UPG(User Private Groups) implementation
    # See https://wiki.debian.org/UserPrivateGroups
    # TODO: Probably we should change pam settings too
    # Note: it throws an error, if uid is not set
    groups = groups // __mapAttrs
      (name: value: (groups.${name} or {}) // { gid = ensure-int users.${name}.uid; })
      users;

  };

in

  {

    # TODO: Make UPG as a nix module so that it is more composable
    users = users-and-groups-with-UPG {
      users."jhhuh" = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "video"
            "vboxusers"
            "lxd"
            "networkmanager"
            "libvirtd"
            "ipfs"
            "podman"
            "docker"
            "incus-admin"
            "disk" ];
          openssh.authorizedKeys.keys = jhhuh-pubkeys;
          uid = 1000;
        };
    };

  }
