self: super: rec {

  systemToolsEnv = with self; self.buildEnv {
    name = "systemToolsEnv";
    paths = [ file bind inotify-tools gnupg gparted ]
      ++ [ (haskell.lib.justStaticExecutables haskellPackages.pandoc) ]
      ++ [ imagemagick_light lsof p7zip paperkey tree unzip ]
      ++ [ watch xz patchelf sshfs-fuse nixops zip ];};
  
  personalToolsEnv = with self; self.buildEnv {
    name = "personalToolsEnv";
    paths = [ aria2 gimp haskellPackages.git-annex iw ]
      ++ [ libressl mplayer pavucontrol ranger reptyr ]
      ++ [ rfkill sl sshuttle tigervnc ]
      ++ [ usbutils vimpc xorg.xwd youtube-dl ]
      ++ [ pythonPackages.pygments ]
      ++ [ compton st tinyemu tmux vimHugeX qemu gitAndTools.hub radare2 ]
      ++ [ hackage-mirror snack-exe xmonadFull lambdabot cachix ]
      ++ [ nix-prefetch-git ]
      ++ [ asciinema manpages posix_man_pages]
      ++ [ direnv ]; };
 
  haskellDevEnv = with self; self.buildEnv {
    name = "haskellDevEnv";
    paths = [ haskellPackages.cabal-install cabal2nix stackage2nix ];
  };
  
  pythonDevEnv = with self; let
    myPython = python36.withPackages (p: with p; [
      jupyter
      scipy numpy pandas matplotlib
      qrcode ]);
  in
    myPython;

}
