{ ... }:

let

  jhhuh-pubkeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOp1CH+oR5hGNRXbxNQ19X0NbltZ+nGMc05qZPj+5dt jhhuh@aero15"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjHaMyKVhfex3wyWkZNQv288qnmy1oDTy/L7J+iht8N jhhuh@x230"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAION2oxUEENwK/lOSU+UdVGQyYkfOpfforL3AJ5BsO69k jhhuh@tres-cantos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGoftvY9HAKWXoL+I4GTOCRQnqRnpgbwaxXjpytAE6kP jhhuh@p1gen3"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIxr4HSvBYCDxAigSKGB2zghw/3RXNnBdQl5HdGCaVZS jhhuh@dasan"
  ];

in

  {

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
      openssh.authorizedKeys.keys = jhhuh-pubkeys;
      uid = 1000;
    };

  }
