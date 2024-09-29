{ pkgs, ... }: {

  nix = {
    package = pkgs.nixFlakes.override {
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
        "http://cafe.coati-bebop.ts.net:5555"
        #"http://mimir.coati-bebop.ts.net:5555"
        #"http://p1gen3.coati-bebop.ts.net:5555"
      ];
      trusted-public-keys = [
        "cache.mimir.asgard-labs.com-1:lw8GZNUYWsCV6letxzfdeF+qmXpgBIEnjoAUWOCBA5w="
        "cache.cafe.asgard-labs.com-1:WvrgWs0irdeOLZkXc22qElWzbyaYWOKiuFluFJoGQos="
        "cache.p1gen3.asgard-labs.com-1:cFBR49pfNUjZ8jY5he5+sKc0RIVuaNmVymgSU8uVAYU="
        "cache.tera001.asgard-labs.com-1:a/R5XcF4/YXX3NAkGnV0AsY9W0xCj4GZdMWLmR3doDM="
        "cache.tera002.asgard-labs.com-1:8ClDcGZKl20XpqGKXCX17QaGdra0HggVc82RYfjlbsE="
        "cache.tera003.asgard-labs.com-1:g42Ayb4Xgywh871K2yyWeIGloNL3EycKl5V+FAWUFTA="
        "cache.tera004.asgard-labs.com-1:hrwDWOOsoeS4tQLcu0VA+29Ok7UkKa0je/gPIf5wumA="
        # "cache.tera005.asgard-labs.com-1:I7d06yGmTuJe2eJjlzf26YWnvDzTEslMpAsay/iU0vw="
        # "cache.tera006.asgard-labs.com-1:nfNXBtZm1OpU8HIvJCeCmvc1dLFXI27MbN6ELr+ERzs="
        # "cache.tera007.asgard-labs.com-1:LKwIJ5QMG9zGSxJf+TWizge6hQ2cJe2YoMCZ0Kwh+QA="
        # "cache.tera008.asgard-labs.com-1:gFsOTK/phBVYPWd8YQlmX7PHoYaBtJRBOJ88H4usJqw="
        # "cache.tera009.asgard-labs.com-1:5HrcQrsJ7Xk//M60P9hHOJXdUHz4m3QybAbr8BScsBU="
        # "cache.tera010.asgard-labs.com-1:QdwmxYsFvbwbKrT/QmMbQWmf8FnQaZ6oat6SkWIolZQ="
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
