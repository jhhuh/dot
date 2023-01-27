import XMonad

import XMonad.Layout.Spacing (
  spacingRaw,
  Border(..))

import XMonad.Prompt (
  XPConfig(..),
  XPPosition(..))

import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh (sshPrompt)
import XMonad.Prompt.XMonad (xmonadPrompt)

import XMonad.Util.NamedScratchpad (
  defaultFloating,
  namedScratchpadAction,
  namedScratchpadManageHook,
  customFloating,
  NamedScratchpad(NS))

import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog (
  statusBar,
  xmobarPP,
  PP(..),
  xmobarColor,
  xmobarStrip,
  shorten,wrap)

import XMonad.Hooks.ManageDocks (
  manageDocks,
  docks,
  avoidStruts) --, ToggleStruts(..))

import XMonad.Layout.Gaps (
  gaps,
  Direction2D(..),
  GapMessage(..))

import qualified Data.Map as M

import XMonad.Hooks.EwmhDesktops (
  ewmh,
  ewmhFullscreen)

import Graphics.X11.ExtraTypes.XF86 (
  xF86XK_MonBrightnessUp,
  xF86XK_MonBrightnessDown)

desktop = ewmhFullscreen . ewmh $ def {
  handleEventHook = handleEventHook def
 }

conf = desktop {
  borderWidth = 0,
  focusedBorderColor = "#ff8267",
  terminal = "xst",
  modMask = mod4Mask,
  keys = keys desktop <+> myKeys,
  manageHook = scratchpadHook
    <+> myManageHook
    <+> manageHook desktop,
  layoutHook = avoidStruts
    $ spacingRaw False
                 (Border 10 10 20 20)
                 True
                 (Border 10 10 10 10)
                 True
    $ gaps [(D,5)]
    $ layoutHook desktop,
  startupHook = myStartupHook <+> startupHook desktop }

myStartupHook =
  spawn "xset r rate 250 50"
 <+> spawn "feh --bg-scale /home/jhhuh/wallpapers/theWallpaper"
 <+> spawn "compton -CGcf -i 0.7 -I 1.0 -O 1.0 -D 0 --detect-client-leader"
 <+> spawn "source ~/.screenlayout/default.sh"

myKeys XConfig { modMask = modm }
  = M.fromList
    [ ( (modm .|. controlMask, xK_p),
        shellPrompt $ def { alwaysHighlight = True,
                            height = 24,
                            promptBorderWidth = 0,
                            position = CenteredAt 0.02 0.5,
                            borderColor = "#000000",
                            fgColor = "#ffffff",
                            bgColor = "#3f3c6d",
                            fgHLight = "#3f3c6d",
                            bgHLight = "#ffffff" } ),
      ( (0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 5" ),
      ( (0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5" ),
      -- ( (modm .|. controlMask, xK_b),
      --   namedScratchpadAction scratchpads "zathura" ),
      ( (modm .|. controlMask, xK_b), spawn "tabbed -c zathura -e" ),
      ( (modm .|. controlMask, xK_q),
        spawn $ unlines [
          "if type xmonad",
          "then",
          "  xmonad --recompile && xmonad --restart",
          "else",
          "  xmessage xmonad not in \\$PATH: \"$PATH\"",
          "fi"] ),
      ( (modm .|. controlMask, xK_F7),
        spawn $ "xrandr --auto" ),
      ( (modm .|. controlMask, xK_F8),
        spawn $ "source ~/.screenlayout/default.sh" ),
      ( (modm .|. controlMask, xK_F9),
        spawn $ "source ~/.screenlayout/home.sh" ),
      ( (modm .|. controlMask, xK_F10),
        spawn $ "source ~/.screenlayout/work.sh" ),
      ( (modm .|. controlMask, xK_s),
        sshPrompt def),
      ( (modm .|. controlMask, xK_h),
        namedScratchpadAction scratchpads "htop"),
      ( (modm .|. controlMask, xK_space),
        namedScratchpadAction scratchpads "ranger"),
      ( (modm .|. controlMask, xK_n),
        namedScratchpadAction scratchpads "xst"),
      ( (modm .|. controlMask, xK_v),
        namedScratchpadAction scratchpads "pavucontrol"),
      ( (modm .|. controlMask, xK_g),
        namedScratchpadAction scratchpads "kotatogram-desktop"),
      ( (modm .|. controlMask, xK_j),
        namedScratchpadAction scratchpads "emacs"),
      ( (modm .|. controlMask, xK_k),
        namedScratchpadAction scratchpads "scrcpy"),
      ( (modm .|. controlMask, xK_u),
        sendMessage $ IncGap 5 D ),
      ( (modm .|. controlMask, xK_d ),
        sendMessage $ DecGap 5 D ),
      ( (modm .|. controlMask, xK_x ),
        xmonadPrompt def ) ]

scratchpads =
  map makeNS [
    ("alsamixer", "alsamixer", 3/8,   3/8,  1/4,   1/4),
    ("htop",      "htop",      21/32, 1/16, 10/32, 14/16),
    ("vimpc",     "vimpc",     1/2,   1/6,  5/12,  2/3),
    ("ranger",    "ranger",    1/6,   1/6,  2/3,   2/3) ] ++
  [ NS "xst" "xst -A 192 -T xst-alpha -f \"Liberation Mono:pixelsize=14\""
       (title =? "xst-alpha")
       (customFloating $
         W.RationalRect (0/32) (0/32) (32/32) (18/32)),
    NS "scrcpy" "scrcpy"
       (className =? ".scrcpy-wrapped")
       (customFloating $
         W.RationalRect (22/32) (1/16) (8/32) (12/16)),
    NS "emacs"
       (unwords $ [
         "emacsclient", "-c"])
       (className =? "Emacs")
       (customFloating $
         W.RationalRect (4/32) (1/32) (24/32) (30/32)),
    NS "PiP"
       (unwords $ [
         ""])
       (className =? "Emacs")
       (customFloating $
         W.RationalRect (1/8) (1/32) (6/8) (30/32)),
    NS "pavucontrol" "pavucontrol"
       (className =? "Pavucontrol")
       (customFloating $
         W.RationalRect (2/8) (2/8) (4/8) (4/8)) ]
  where makeNS (name,cmd,px,py,w,h)
          = NS name (terminalCmd++cmd)
               (title =? name )
               (customFloating $ W.RationalRect px py w h)
        terminalCmd = "st -e "

scratchpadHook = namedScratchpadManageHook scratchpads

myManageHook = composeAll . concat $
    [ [resource=?t   --> doFloat | t <- myFloatsByResource],
      [className=?c  --> doFloat | c <- myFloatsByClass ],
      [title=?t      --> doFloat | t <- myFloatsByTitle ],
      [stringProperty "WM_WINDOW_ROLE" =? r --> doFloat
        | r <- myFloatsByRole]]
  where myFloatsByResource = ["Devtools",
                              "plasmashell"]
        myFloatsByClass = [] -- "Emacs"]
        myFloatsByTitle = ["Open Document",
                           "Open Files",
                           "Developer Tools"]
        myFloatsByRole = ["pop-up",
                          "bubble"]


-- Command to launch the bar.
myBar = unwords [
  "/home/jhhuh/.xmonad/xmobar.sh",
  "/home/jhhuh/.xmonad/xmobar.hs"]

-- Custom PP.
myXmobarPP = xmobarPP
    { ppCurrent = xmobarColor "#f8f8f8"
                              "DodgerBlue4"
                    . wrap " " " "
    , ppVisible = xmobarColor "#f8f8f8"
                              "LightSkyBlue4"
                    . wrap " " " "
    , ppUrgent  = xmobarColor "#f8f8f8"
                              "red4"
                    . wrap " " " "
                    . xmobarStrip
    , ppLayout  = wrap "" ""
                    . xmobarColor "DarkOrange" ""
                    . wrap " [" "] "
    , ppTitle   = xmobarColor "#61ce3c" ""
                    . shorten 50
    , ppSep     = ""
    , ppWsSep   = " "
    }

toggleStrutsKey XConfig {XMonad.modMask = modMask}
  = (modMask, xK_b)

main :: IO ()
main = xmonad =<< statusBar myBar myXmobarPP toggleStrutsKey conf
