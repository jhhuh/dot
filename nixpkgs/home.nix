{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    kotatogram-desktop
  ];

  programs = {
    home-manager = {
      enable = true;
    };

    firefox.enable = true;

    emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [vterm];
    };
  };
}
