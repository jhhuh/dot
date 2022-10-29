{ pkgs, ... }: {

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
        #"http://mimir.coati-bebop.ts.net:5555"
        "http://p1gen3.coati-bebop.ts.net:5555"
      ];
      trusted-public-keys = [
        "cache.mimir.asgard-labs.com-1:lw8GZNUYWsCV6letxzfdeF+qmXpgBIEnjoAUWOCBA5w="

        "cache.p1gen3.asgard-labs.com-1:cFBR49pfNUjZ8jY5he5+sKc0RIVuaNmVymgSU8uVAYU=";
      ];
    };
  };

  # To generate signing key
  #
  # > sudo su
  # $ mkdir /root/.secrets
  # $ chmod 700 /root/.secrets
  # $ nix-store --generate-binary-cache-key cache.$HOSTNAME.asgard-labs.com-1 /root/.secrets/nix-serve.secret /root/.secrets/nix-serve.public

  services.nix-serve = {
    enable = true;
    port = 5555;
    openFirewall = true;
    secretKeyFile = "/root/.secrets/nix-serve.secret";
  };

}
