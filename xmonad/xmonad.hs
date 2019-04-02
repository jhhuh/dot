import XMonad
-- import XMonad.Config.Desktop (desktopConfig)

import XMonad.Hooks.DynamicLog (dzenWithFlags)
import XMonad.Hooks.ManageDocks (manageDocks, docks, avoidStruts) --, ToggleStruts(..))

import XMonad.Layout.Spacing (spacingRaw, Border(..))
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh (sshPrompt)

import XMonad.Prompt (XPConfig(..),XPPosition(..))
import XMonad.Util.NamedScratchpad ( defaultFloating, namedScratchpadAction
                                   , namedScratchpadManageHook
                                   , customFloating
                                   , NamedScratchpad (NS) )

import qualified XMonad.StackSet as W

import XMonad.Util.Run (spawnPipe)

import qualified Data.Map as M
import qualified Data.Char as C


desktop = defaultConfig

wallpaper = "~/Pictures/anime_landscape_tree_y_girl_cute_long_hair_2560x1080.jpg"

conf = desktop { borderWidth = 4
               , focusedBorderColor = "#ff8267"
               , terminal = "urxvt"
               , modMask = mod4Mask
               , keys = myKeys <+> keys desktop
               , manageHook =  manageDocks
                               <+> scratchpadHook
                               <+> manageHook desktop
                               <+> myManageHook
               , layoutHook = avoidStruts
                              $ spacingRaw False (Border 8 8 16 16) True
                                                 (Border 16 16 16 16) True
                              $ layoutHook desktop
               , startupHook = (spawn . unwords) ["compton", "-CGcf"
                                               , "-i 0.7", "-I 1.0 -O 1.0 -D 0"
                                               , "--detect-client-leader"
                                               ,  "--focus-exclude"
                                               , "'class_i=\"xv\"||_NET_WM_NAME@:s *?=\"Netflix\"'"]
                               <+> spawn "xrandr --output eDP1 --off"
                               <+> spawn "xset r rate 250 50"
                               <+> (spawn . unwords) [ "feh --bg-scale", wallpaper ] }

scratchpads = let
    makeNS (name,cmd,px,py,w,h) = NS name (terminalCmd++cmd) (title =? name) (customFloating $ W.RationalRect px py w h)
    terminalCmd = "urxvt -fn \"xft:Bitstream Vera Sans Mono:pixelsize=11\" -rv -e "
  in
    map makeNS [
      ( "alsamixer",        "alsamixer",           3/8,  3/8, 1/4,  1/4 ),
      ( "htop",             "htop",                11/16,  1/16, 4/16,  14/16 ),
      ( "vimpc",            "vimpc",               1/2,  1/6, 5/12, 2/3 ),
      ( "ranger",           "ranger",              1/6,  1/6, 2/3,  2/3 ),
      ( "nix-env",          "nix-env -qaPA nixos", 2/3,  2/3, 1/3,  1/3 ) ]
    ++
      [ NS "telegram-desktop" "telegram-desktop"
           ( className =? "TelegramDesktop")
           ( customFloating $ W.RationalRect (1/8) (1/8) (3/4) (3/4) )
      , NS "emacseditor"      "emacseditor"
           ( className =? "Emacs")
           ( customFloating $ W.RationalRect (1/8) (1/16) (2/4) (7/8) )
      , NS "zathura"      "zathura"
           ( className =? ".zathura-wrapped_")
           ( customFloating $ W.RationalRect (1/16) (1/64) (8/16) (62/64) )
      , NS "pavucontrol"      "pavucontrol"
           ( className =? "Pavucontrol")
           ( customFloating $ W.RationalRect (2/8) (2/8) (4/8) (4/8) ) ]

myKeys XConfig { modMask = modm } =
    M.fromList [ ((modm, xK_p), customShellPrompt)
               , ((modm .|. controlMask, xK_i), spawn "xcalib -i -a; xrandr --output eDP1 --off")
               , ((modm .|. controlMask, xK_F12), spawn "xrandr --output eDP1 --off")
               , ((modm .|. controlMask, xK_s), sshPrompt def)
               , ((modm .|. controlMask, xK_b), namedScratchpadAction scratchpads "zathura")
               , ((modm .|. controlMask, xK_h), namedScratchpadAction scratchpads "htop")
               , ((modm .|. controlMask, xK_m), namedScratchpadAction scratchpads "vimpc")
               , ((modm .|. controlMask, xK_space), namedScratchpadAction scratchpads "ranger")
               , ((modm .|. controlMask, xK_n), namedScratchpadAction scratchpads "nix-env")
               , ((modm .|. controlMask, xK_v), namedScratchpadAction scratchpads "pavucontrol")
               , ((modm .|. controlMask, xK_g), namedScratchpadAction scratchpads "telegram-desktop")
               , ((modm .|. controlMask, xK_j), namedScratchpadAction scratchpads "emacseditor") ]
  where
    customShellPrompt = shellPrompt $ def { alwaysHighlight = True
                                          , height = 42
                                          , promptBorderWidth = 4
                                          , position = CenteredAt 0.02 0.5
                                          , borderColor = "#000000"
                                          , fgColor = "#ffffff"
                                          , bgColor = "#3f3c6d"
                                          , fgHLight = "#3f3c6d"
                                          , bgHLight = "#ffffff"
                                          , font = "xft:Ubuntu Mono :pixelsize=32" }

scratchpadHook = namedScratchpadManageHook scratchpads

myManageHook = composeAll . concat $ [
         [ resource    =? t --> doFloat           | t <- myFloatsByResource ]
       , [ className   =? c --> doFloat           | c <- myFloatsByClass ]
       , [ title       =? t --> doFloat           | t <- myFloatsByTitle ] ]
     where myFloatsByResource = [ "Devtools" ]
           myFloatsByClass = [ ]
           myFloatsByTitle = [ "Open Document", "Open Files" , "Developer Tools" ]

main :: IO ()
main = xmonad =<< dzenWithFlags dzenFlags (docks conf)
  where dzenFlags = unwords [ "-dock -e", "'onstart=lower'"
                            , "-w 2560", "-y -10", "-ta l"
                            , "-fg '#a8a3f7'", "-bg '#3f3c6d'"]
