{ pkgs }: {
  allowUnfree = true;
  allowBroken = true;
  mplayer = { pulseSupport = true; };
}
