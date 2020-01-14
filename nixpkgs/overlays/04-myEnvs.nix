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
        :imap jk <Esc>

        let base16colorspace=256
        colorscheme base16-atelier-plateau-light

        let g:jedi#use_tabs_not_buffers = 1

        function! SourceIfExists(file)
          if filereadable(expand(a:file))
            exe 'source' a:file
          endif
        endfunction

        let $MYVIMRC="~/.vimrc"
        call SourceIfExists($MYVIMRC)
      '';
      packages.myVimPackage = with self.vimPlugins; {
        start = [ jedi-vim base16-vim ];
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
      ++ [ compton tmux qemu gitAndTools.hub radare2 ]
      ++ [ xmonadFull ]
      ++ [ nix-prefetch-git ]
      ++ [ asciinema manpages posix_man_pages]
      ++ [ direnv st ]
      ++ [ scrcpy ]; };

  haskellDevEnv = with self; self.buildEnv {
    name = "haskellDevEnv";
    paths = [ haskellPackages.cabal-install cabal2nix stack ];
    #stackage2nix -- Hard to maintain
  };
  
  pythonDevEnv = with self; let
    myPython = python36.withPackages (p: with p; [
      jupyter
      scipy numpy pandas matplotlib
      qrcode ]);
  in
    myPython;

  all-hies = let
    all-hies_HEAD = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  in all-hies_HEAD.selection { selector = p: p; };

}
