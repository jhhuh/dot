{ pkgs, ... }: {

  nix = {
    package = pkgs.nixVersions.stable.override {
      editline = pkgs.editline.overrideAttrs (old: {
        configureFlags = old.configureFlags or [] ++ [ "--enable-sigstop" ];
      });
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
      experimental-features = nix-command flakes

      bash-prompt-suffix = \[\033[1;33m\]\n(nix develop)\$ \[\033[0m\]
    '';


    settings = {
      trusted-users = [ "@wheel" ];
      substituters = [
        "http://zhao.coati-bebop.ts.net:5555"
        #"http://cafe.coati-bebop.ts.net:5555"
        #"http://mimir.coati-bebop.ts.net:5555"
        #"http://p1gen3.coati-bebop.ts.net:5555"
      ];
      trusted-public-keys = [
        "cache.zhao.asgard-labs.com-1:IQxwlO8En0q/ugGOmvSr2UCPMY/8mv9V8Brvi/8Cf1I="
        "cache.mimir.asgard-labs.com-1:lw8GZNUYWsCV6letxzfdeF+qmXpgBIEnjoAUWOCBA5w="
        "cache.cafe.asgard-labs.com-1:WvrgWs0irdeOLZkXc22qElWzbyaYWOKiuFluFJoGQos="
        "cache.p1gen3.asgard-labs.com-1:cFBR49pfNUjZ8jY5he5+sKc0RIVuaNmVymgSU8uVAYU="
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
