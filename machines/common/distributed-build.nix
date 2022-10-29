{ config, ... }:

let

  inherit (builtins) concatLists map attrValues removeAttrs;

  users-authorized-for-builder = [ "jhhuh" ];

  builder-pubkeys =
    concatLists
      (map
        (user: config.users.users.${user}.openssh.authorizedKeys.keys)
        users-authorized-for-builder);
in 

  {

    nix.distributedBuilds = true;

    nix.buildMachines =
      let
        builder-specs =
          removeAttrs
            (import ../builder-specs.nix)
            [ config.networking.hostName ];
      in attrValues builder-specs;

    users.users."builder" = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = builder-pubkeys;
    };

    services.nix-serve = {
      enable = true;
      port = 5555;
      openFirewall = true;
      secretKeyFile = "/root/.secrets/nix-serve.secret";
    };

  }
