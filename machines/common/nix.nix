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
        "http://mimir.coati-bebop.ts.net:5555"
      ];
      trusted-public-keys = [
        "cache.mimir.asgard-labs.com-1:lw8GZNUYWsCV6letxzfdeF+qmXpgBIEnjoAUWOCBA5w="
      ];
    };
  };

}
