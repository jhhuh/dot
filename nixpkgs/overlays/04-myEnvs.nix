self: super: rec {

  systemToolsEnv = with self; self.buildEnv {
    name = "systemToolsEnv";
    paths = [ file bind inotify-tools gnupg gparted ]
      ++ [ (haskell.lib.justStaticExecutables haskellPackages.pandoc) ]
      ++ [ imagemagick_light lsof p7zip paperkey tree unzip ]
      ++ [ watch xz patchelf sshfs-fuse nixops zip ];};

  myVim = self.vim_configurable.customize {
    name = "vim";
    vimrcConfig = {
      customRC = ''
        colorscheme base16-atelier-plateau-light
      '';
      packages.myVimPackage = with self.vimPlugins; {
        start = [ base16-vim ];
      };
    };
  };
  
  personalToolsEnv = with self; let
  in self.buildEnv {
    name = "personalToolsEnv";
    paths = [ aria2 gimp haskellPackages.git-annex iw ]
      ++ [ libressl mplayer pavucontrol ranger reptyr ]
      ++ [ rfkill sshuttle] # sl tigervnc 
      ++ [ usbutils youtube-dl ] # vimpc xorg.xwd
      ++ [ pythonPackages.pygments ]
      ++ [ compton tinyemu tmux qemu gitAndTools.hub radare2 ]
      #++ [ hackage-mirror
      ++ [ snack-exe xmonadFull cachix ] #lambdabot cachix ]
      ++ [ nix-prefetch-git ]
      ++ [ asciinema manpages posix_man_pages]
      ++ [ direnv st_base16 ]
      ++ [ scrcpy ws ]; };
 
  haskellDevEnv = with self; self.buildEnv {
    name = "haskellDevEnv";
    paths = [ haskellPackages.cabal-install cabal2nix ]; #stackage2nix ];
  };

  all-hies = let
    all-hies_master = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  in
    all-hies_master.selection { selector = p: p; };

  pythonDevEnv = with self; let
    myPython = python36.withPackages (p: with p; [
      jupyter
      scipy numpy pandas matplotlib
      qrcode ]);
  in
    myPython;
}
