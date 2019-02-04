import XMonad

import XMonad.Config.Kde (kde4Config)

import XMonad.Layout.Spacing (spacingRaw, Border(..))
import XMonad.Prompt (XPConfig(..),XPPosition(..))
import XMonad.Util.NamedScratchpad ( defaultFloating, namedScratchpadAction
                                   , namedScratchpadManageHook
                                   , customFloating
                                   , NamedScratchpad (NS) )

import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog (dzenWithFlags)
import XMonad.Hooks.ManageDocks (manageDocks, docks, avoidStruts) --, ToggleStruts(..))
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh (sshPrompt)

import qualified Data.Map as M

desktop = kde4Config

conf = desktop { borderWidth = 2
               , focusedBorderColor = "#ff8267"
               , terminal = "st -f \"Liberation Mono:pixelsize=14\""
               , modMask = mod4Mask
               , keys = keys desktop <+> myKeys
               , manageHook = scratchpadHook
                                <+> myManageHook
                                <+> manageHook desktop
               , layoutHook = avoidStruts
                                $ spacingRaw False (Border 4 4 8 8) True
                                                   (Border 8 8 8 8) True
                                $ layoutHook desktop
               , startupHook = myStartupHook <+> startupHook desktop }
myStartupHook = spawn "xset r rate 250 50" 
                  <+> spawn "compton -CGcf -i 0.7 -I 1.0 -O 1.0 -D 0 --detect-client-leader"
myKeys XConfig { modMask = modm } = M.fromList
  [ ( (modm .|. controlMask, xK_p), shellPrompt $ def { alwaysHighlight = True
                                                      , height = 24
                                                      , promptBorderWidth = 0
                                                      , position = CenteredAt 0.02 0.5
                                                      , borderColor = "#000000"
                                                      , fgColor = "#ffffff"
                                                      , bgColor = "#3f3c6d"
                                                      , fgHLight = "#3f3c6d"
                                                      , bgHLight = "#ffffff" } )
  , ( (modm .|. controlMask, xK_b), namedScratchpadAction scratchpads "zathura")
  , ( (modm .|. controlMask, xK_q), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
  , ( (modm .|. controlMask, xK_s), sshPrompt def)
  , ( (modm .|. controlMask, xK_h), namedScratchpadAction scratchpads "htop")
  , ( (modm .|. controlMask, xK_m), namedScratchpadAction scratchpads "vimpc")
  , ( (modm .|. controlMask, xK_space), namedScratchpadAction scratchpads "ranger")
  , ( (modm .|. controlMask, xK_n), namedScratchpadAction scratchpads "nix-env")
  , ( (modm .|. controlMask, xK_v), namedScratchpadAction scratchpads "pavucontrol")
  , ( (modm .|. controlMask, xK_g), namedScratchpadAction scratchpads "telegram-desktop")
  , ( (modm .|. controlMask, xK_j), namedScratchpadAction scratchpads "emacseditor") ]

scratchpads =
  map makeNS [ ( "alsamixer",        "alsamixer",           3/8,  3/8, 1/4,  1/4 ),
               ( "htop",             "htop",                21/32,  1/16, 10/32,  14/16 ),
               ( "vimpc",            "vimpc",               1/2,  1/6, 5/12, 2/3 ),
               ( "ranger",           "ranger",              1/6,  1/6, 2/3,  2/3 ),
               ( "nix-env",          "nix-env -qaPA nixos", 2/3,  2/3, 1/3,  1/3 ) ]
    ++
     [ NS "emacseditor"      "emacsclient -c"   (className =? "Emacs")
          (customFloating $ W.RationalRect (1/32) (1/16) (19/32) (14/16) )
     , NS "zathura"          "zathura"          (className =? "Zathura")
          (customFloating $ W.RationalRect (1/8) (1/16) (6/8) (14/16) ) 
     , NS "pavucontrol"      "pavucontrol"      (className =? "Pavucontrol")
          (customFloating $ W.RationalRect (2/8) (2/8) (4/8) (4/8) ) ]
  where makeNS (name,cmd,px,py,w,h) = NS name (terminalCmd++cmd)
                                         (title =? name ) (customFloating $ W.RationalRect px py w h)
        terminalCmd = "st -e "                          
                                                        
scratchpadHook = namedScratchpadManageHook scratchpads  
                                                        
myManageHook = composeAll . concat $ [ [ resource  =? t  --> doFloat | t <- myFloatsByResource ]
                                     , [ className =? c  --> doFloat | c <- myFloatsByClass ]
                                     , [ title     =? t  --> doFloat | t <- myFloatsByTitle ] ]
  where myFloatsByResource = [ "Devtools", "plasmashell" ]
        myFloatsByClass = [ ]
        myFloatsByTitle = [ "Open Document", "Open Files" , "Developer Tools" ]

main :: IO ()
main = xmonad conf
