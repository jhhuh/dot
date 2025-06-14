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

import XMonad.Hooks.StatusBar

import XMonad.Hooks.ManageDocks (
  manageDocks,
  docks,
  avoidStruts) --, ToggleStruts(..))

import XMonad.Layout.Gaps (
  gaps,
  Direction2D(..),
  GapMessage(..))

import XMonad.Actions.FloatKeys (keysMoveWindow, keysResizeWindow)

import qualified Data.Map as M

import Data.Maybe (fromMaybe)
import Data.Ratio ((%))
import Control.Monad (guard)

import XMonad.Hooks.EwmhDesktops (
  ewmh,
  ewmhFullscreen)

import Graphics.X11.ExtraTypes.XF86 (
  xF86XK_MonBrightnessUp,
  xF86XK_MonBrightnessDown)

import XMonad.Actions.CopyWindow

desktop = ewmhFullscreen . ewmh $ def {
  handleEventHook = handleEventHook def
 }

conf = desktop {
  borderWidth = 0,
  focusedBorderColor = "#000000",
  terminal = "st -f \"UbuntuMono Nerd Font:pixelsize=36\"",
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
 <+> spawn "hsetroot -solid '#937591' -cover ~/wallpapers/theWallpaper"
-- <+> spawn "compton -CGcf -i 0.7 -I 1.0 -O 1.0 -D 0 --detect-client-leader"
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
      ( (modm .|. controlMask, xK_q),
        spawn $ unlines [
          "if type xmonad",
          "then",
          "  xmonad --recompile && xmonad --restart",
          "else",
          "  xmessage xmonad not in \\$PATH: \"$PATH\"",
          "fi"] ),
      ( (modm .|. controlMask, xK_F7),
        spawn $ "xrandr --auto; pkill picom" ),
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
        namedScratchpadAction scratchpads "terminal"),
      ( (modm .|. controlMask, xK_f),
        namedScratchpadAction scratchpads "ranger"),
      ( (modm .|. controlMask, xK_b),
        namedScratchpadAction scratchpads "zathura" ),
      ( (modm .|. controlMask, xK_n),
        namedScratchpadAction scratchpads "xst"),
      ( (modm .|. controlMask, xK_v),
        namedScratchpadAction scratchpads "pavucontrol"),
      ( (modm .|. controlMask, xK_r),
        namedScratchpadAction scratchpads "kotatogram-desktop"),
      ( (modm .|. controlMask, xK_j),
        namedScratchpadAction scratchpads "emacs"),
      ( (modm .|. controlMask, xK_k),
        namedScratchpadAction scratchpads "scrcpy"),
      ( (modm .|. controlMask, xK_m),
        namedScratchpadAction scratchpads "keybase-gui"),
      ( (modm .|. controlMask, xK_g),
        namedScratchpadAction scratchpads "nixpkgs-search"),
      -- ( (modm .|. controlMask, xK_semicolon),
      --   namedScratchpadAction scratchpads "browser"),
      ( (modm .|. controlMask, xK_u),
        sendMessage $ IncGap 5 D ),
      ( (modm .|. controlMask, xK_d ),
        sendMessage $ DecGap 5 D ),
      ( (modm .|. controlMask, xK_x ),
        xmonadPrompt def )
      -- Floating Window resizing
      , ( (modm .|. shiftMask, xK_u ), withFocused $ keysResizeWindow (0, 10) (0, 0)) -- enlarge down
      , ( (modm .|. shiftMask, xK_i ), withFocused $ keysResizeWindow (0, -10) (0, 0)) -- shrink down
      , ( (modm .|. shiftMask, xK_y ), withFocused $ keysResizeWindow (-10, 0) (0, 0)) -- shrink right
      , ( (modm .|. shiftMask, xK_o ), withFocused $ keysResizeWindow (10, 0) (0, 0)) -- enlarge right
      , ( (modm .|. controlMask, xK_u ), withFocused $ keysResizeWindow (0, -10) (0, 1)) -- shrink up
      , ( (modm .|. controlMask, xK_i ), withFocused $ keysResizeWindow (0, 10) (0, 1)) -- enlarge up
      , ( (modm .|. controlMask, xK_y ), withFocused $ keysResizeWindow (10, 0) (1, 0)) -- enlarge left
      , ( (modm .|. controlMask, xK_o ), withFocused $ keysResizeWindow (-10, 0) (1, 0)) -- shrink left
      -- Floating Window moving
      , ( (modm, xK_i), withFocused $ keysMoveWindow (0, -9))
      , ( (modm, xK_u), withFocused $ keysMoveWindow (0, 9))
      , ( (modm, xK_o), withFocused $ keysMoveWindow (16, 0))
      , ( (modm, xK_y), withFocused $ keysMoveWindow (-16, 0))
      -- Window floating at a custom position
      , ( (modm, xK_z), withFocused $ floatToRationalRect myLeft)
      , ( (modm, xK_x), withFocused $ floatToRationalRect myLeftCenter)
      -- , ( (modm .|. shiftMask .|. controlMask, xK_c), withFocused $ floatToRationalRect myCenterSmall)
      , ( (modm .|. shiftMask, xK_f), withFocused $ floatToRationalRect myFocusBig)
      , ( (modm, xK_c), withFocused $ floatToRationalRect myCenter)
      , ( (modm, xK_v), withFocused $ floatToRationalRect myRightCenter)
      , ( (modm, xK_b), withFocused $ floatToRationalRect myRight)
      , ( (modm, xK_f), withFocused $ floatToRationalRect myFocus)
      , ( (modm,  xK_a), windows copyToAll ) -- Pin to all workspaces
      , ( (modm .|. controlMask, xK_a), killAllOtherCopies ) -- remove window from all but current
      , ( (modm .|. shiftMask, xK_a), kill1 ) -- remove window from current, kill if only one
    ]


myCenter, myFocus, myFocusBig, myLeft, myRight, myLeftCenter, myRightCenter:: W.RationalRect
myCenter      = W.RationalRect ( 8 / 32) (1 / 32) (16 / 32) (30 / 32)
myFocus       = W.RationalRect ( 1 /  6) (1 /  6) ( 2 /  3) (2  /  3)
myFocusBig    = W.RationalRect ( 2 / 32) (2 / 32) (28 / 32) (28 / 32)
myLeft        = W.RationalRect ( 1 / 64) (1 / 32) (15 / 32) (30 / 32)
myRight       = W.RationalRect (33 / 64) (1 / 32) (15 / 32) (30 / 32)
myLeftCenter  = W.RationalRect ( 1 / 64) (1 / 32) (21 / 32) (30 / 32)
myRightCenter = W.RationalRect (10 / 32) (1 / 32) (21 / 32) (30 / 32)


floatToRationalRect :: W.RationalRect -> Window -> X ()
floatToRationalRect rr' w = do
  floats <- gets (W.floating . windowset)
  (sc, rr) <- floatLocation w
  if w `M.member` floats && rr `almostSame` rr' -- if the current window is floating...
    then (windows . W.sink) w
    else do
      windows $ \ws -> W.float w rr' . fromMaybe ws $ do
        i <- W.findTag w ws
        guard $ i `elem` map (W.tag . W.workspace) (W.screens ws)
        f <- W.peek ws
        sw <- W.lookupWorkspace sc ws
        return (W.focusWindow f . W.shiftWin sw w $ ws)
  where
    almostSame :: W.RationalRect -> W.RationalRect -> Bool
    almostSame (W.RationalRect px py wx wy) (W.RationalRect px' py' wx' wy') =
      rd px px' <= tol
        && rd py py' <= tol
        && rd wx wx' <= tol
        && rd wy wy' <= tol
      where
        tol = 1 % 100
        rd a b = 2 * abs (a - b) / (a + b) -- relative difference


-- If the window is floating then (f), if tiled then (n)
ifFloatThenElse :: X () -> X () -> X ()
ifFloatThenElse f n = withFocused $ \windowId -> do
  floats <- gets (W.floating . windowset)
  if windowId `M.member` floats -- if the current window is floating...
    then f
    else n


ifFloatThenSinkElse :: X () -> X ()
ifFloatThenSinkElse = ifFloatThenElse (withFocused $ windows . W.sink)

scratchpads =
  map makeNS [
    ("alsamixer", "alsamixer", 3/8,   3/8,  1/4,   1/4),
    ("htop",      "htop",      21/32, 1/16, 10/32, 14/16),
    ("vimpc",     "vimpc",     1/2,   1/6,  5/12,  2/3),
    ("ranger",    "ranger",    1/6,   1/6,  2/3,   2/3)
  ] ++
  [ NS "xst" "st -A 0.5 -T xst-alpha -f \"Liberation Mono:pixelsize=24\""
       (title =? "xst-alpha")
       (customFloating $
         W.RationalRect (0/400) (300/400) (400/400) (100/400)),
    NS "terminal" ("st -A 0.9 -f \"UbuntuMono Nerd Font:pixelsize=36\" -T st-256color-scratchpad -e bash -i -c 'tmux new-session -A -s scratch'")
       (title =? "st-256color-scratchpad")
       (customFloating $
         W.RationalRect (1/6) (1/6) (2/3) (2/3)),
    -- NS "browser" ("(firefox && sleep 1 && xdotool search --onlyvisible --class firefox) | head -n1 | xargs xdotool set_window --class firefox-scratchpad")
    --    (className =? "firefox-scratchpad")
    --    (customFloating $
    --      W.RationalRect (1/6) (1/6) (2/3) (2/3)),
    NS "kotatogram-desktop" "kotatogram-desktop"
       (className =? "KotatogramDesktop")
       (customFloating $
         W.RationalRect (22/32) (1/16) (8/32) (12/16)),
    NS "keybase-gui" "keybase-gui"
       (className =? "Keybase")
       (customFloating $
         W.RationalRect (22/32) (1/16) (8/32) (12/16)),
    NS "scrcpy" "scrcpy -d"
       (className =? ".scrcpy-wrapped")
       (customFloating $
         W.RationalRect (22/32) (1/16) (8/32) (12/16)),
    NS "emacs"
       (unwords $ [
         "emacsclient", "-c"])
       (className =? "Emacs")
       (customFloating $
         W.RationalRect (2/32) (2/32) (28/32) (28/32)),
    NS "zathura" "zathura"
       (appName =? "org.pwmt.zathura")
       (customFloating $
         W.RationalRect (1/8) (1/32) (6/8) (30/32)),
    NS "pavucontrol" "pavucontrol"
       (className =? "Pavucontrol")
       (customFloating $
         W.RationalRect (2/8) (2/8) (4/8) (4/8)),
    NS "nixpkgs-search" "st -c nixpkgs-search -f \"UbuntuMono Nerd Font:pixelsize=20\" -e bash -i -c \"cd $HOME/nixpkgs && fzf --reverse --preview 'bat --color=always --decorations=always {}' | xargs bat --paging=always\""
       (className =? "nixpkgs-search")
       (customFloating $
         W.RationalRect (1/6) (1/6) (2/3) (2/3))
      ]
  where makeNS (name,cmd,px,py,w,h)
          = NS name (terminalCmd++cmd)
               (title =? name )
               (customFloating $ W.RationalRect px py w h)
        terminalCmd = "st -A 0.9 -f \"UbuntuMono Nerd Font:pixelsize=36\" -e "

scratchpadHook = namedScratchpadManageHook scratchpads

myManageHook = composeAll . concat $
    [ [resource=?t   --> doFloat | t <- myFloatsByResource],
      [className=?c  --> doFloat | c <- myFloatsByClass ],
      [title=?t      --> doFloat | t <- myFloatsByTitle ],
      [stringProperty "WM_WINDOW_ROLE" =? r --> doFloat
        | r <- myFloatsByRole]]
  where myFloatsByResource = ["Devtools",
                              "plasmashell"]
        myFloatsByClass = [ "VirtualBox Machine"]
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
    -- { ppCurrent = xmobarColor "white" ""
    --                 . wrap "[" "]"
    -- , ppVisible = xmobarColor "black" ""
    --                 . wrap "" ""
    -- , ppUrgent  = xmobarColor "black" "red"
    --                 . wrap "!" "!"
    --                 . xmobarStrip
    -- , ppLayout  = wrap "" ""
    --                 . xmobarColor "blue4" ""
    --                 . wrap "{" "}"
    -- , ppTitle   = xmobarColor "black" ""
    --                 . shorten 50
    -- , ppSep     = " <> "
    -- , ppWsSep   = "|"
    -- }

toggleStrutsKey XConfig {XMonad.modMask = modMask}
  = (modMask .|. shiftMask, xK_b)

mySB = statusBarProp myBar (pure myXmobarPP)

main :: IO ()
main = xmonad =<< statusBar myBar myXmobarPP toggleStrutsKey conf
--main = xmonad . withSB mySB . ewmh . docks $ conf

