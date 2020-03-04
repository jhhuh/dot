self: super: rec {

  systemToolsEnv = with self; hiPrio (buildEnv {
    name = "systemToolsEnv";
    paths = [ file bind inotify-tools gnupg gparted ]
      ++ [ (haskell.lib.justStaticExecutables haskellPackages.pandoc) ]
      ++ [ imagemagick_light lsof p7zip paperkey tree unzip ]
      ++ [ watch xz patchelf sshfs-fuse nixops zip ]
      ++ [ xorg.xev scrot pciutils ntfs3g nmap lshw inetutils git ]
      ++ [ acpi acpilight bluez binutils feh htop jq loc mosh powertop ] ;});

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

  qemu = super.qemu.overrideAttrs (attr: {
    buildInputs = attr.buildInputs ++ [ self.libxkbcommon ];});

  personalToolsEnv = with self; let
  in hiPrio (self.buildEnv {
    name = "personalToolsEnv";
    paths = [ aria2 gimp haskellPackages.git-annex iw ]
      ++ [ libressl mplayer pavucontrol ranger reptyr ]
      ++ [ rfkill sshuttle] # sl tigervnc 
      ++ [ usbutils youtube-dl ] # vimpc xorg.xwd
      ++ [ compton tmux qemu gitAndTools.hub radare2 ]
      ++ [ xmonadFull xmobar ]
      ++ [ nix-prefetch-git ]
      ++ [ asciinema manpages posix_man_pages]
      ++ [ direnv st ]
      ++ [ scrcpy irssi magic-wormhole taskwarrior ]
      ++ [ tmate smtube virtmanager virt-viewer ws xar xorg.xclock ]
      ++ [ xpra zathura zeal scummvm myVim appimage-run cachix electrum ]
      ++ [ go-ethereum rclone ]
      ++ [ firefox google-chrome ]
      ++ (with nodePackages; [ node2nix http-server ]); });

  haskellDevEnv = with self; self.buildEnv {
    name = "haskellDevEnv";
    paths = [ haskellPackages.cabal-install cabal2nix stack ];
    #stackage2nix -- Hard to maintain
  };

  all-hies = let
    all-hies_master = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  in
    all-hies_master.selection { selector = p: p; };

  pythonDevEnv = with self; let
    myPython = python37.withPackages (p: with p; [
      jupyter pip
      scipy numpy pandas matplotlib
      qrcode selenium ]);
  in
    myPython;

}
