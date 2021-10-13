{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat htop tree
    nextcloud-client
    kotatogram-desktop gnome.gnome-tweaks mattermost-desktop
    google-chrome
    gnomeExtensions.appindicator
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
