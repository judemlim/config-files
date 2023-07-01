import XMonad hiding ( (|||) ) -- jump to layout
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||)) -- jump to layout
import XMonad.Config.Desktop
import Data.Monoid
import Data.Ratio ((%)) -- for video
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- system
import System.IO (hPutStrLn) -- for xmobar

-- util
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)  
import XMonad.Util.NamedScratchpad

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops -- for rofi
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat) 
import XMonad.Hooks.Place (placeHook, withGaps, smart)

-- actions
import XMonad.Actions.CopyWindow -- for dwm window style tagging
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer -- mouse follows focus

-- layout 
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.GridVariants
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Reflect
import XMonad.Layout.ThreeColumns
import XMonad.Layout.CenteredMaster
import XMonad.Layout.MultiColumns

-- New things
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Magnifier

-- xmobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers

------------------------------------------------------------------------
-- config
------------------------------------------------------------------------

myModMask       = mod4Mask  -- Sets modkey to super/windows key
myTerminal      = "alacritty"   -- Sets default terminal
myBorderWidth   = 5         -- Sets border width for windows
-- myNormalBorderColor = "#839496"
myFocusedBorderColor = "#b1eea8"
-- myppCurrent = "#268BD2"
-- myppVisible = "#268BD2"
-- myppHidden = "#B58900"
-- myppHiddenNoWindows = "#93A1A1"
-- myppTitle = "#FDF6E3"
-- myppUrgent = "#DC322F"
-- myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
-- windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- Startup hook
------------------------------------------------------------------------

myStartupHook = do
      spawnOnce "unclutter --timeout 2 &"
      -- spawnOnce "picom &"  
      --spawnOnce "sudo logid"  
      --spawnOnce "psensor &"  
      spawn "~/Scripts/refresh_wallpaper.sh"  
      spawnOnce "discord > /dev/null 2>&1 &!"  
      spawnOnce "sleep 10 && thunderbird "  
      spawnOnce "sleep 1 && ~/.screenlayout/home.sh "  
      spawnOnce "sleep 1 && slack "  
      spawnOnce "sleep 5 && trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --tint 0x191970 --height 20 --distancefrom right"  
      spawn "xset r rate 200 25"  

      -- Proton startup
      -- Run nm-applet in background to create an agent so that it can be  used by the vpn.
      -- The killswitch being on prevents proton from starting I think.
      -- spawnOnce "sleep 1 && nm-applet &! protonvpn-cli killswitch --off && protonvpn-cli c -f"  
      spawnOnce "sleep 1 && protonmail-bridge "  

------------------------------------------------------------------------
-- Window rules:
------------------------------------------------------------------------

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "mpv"            --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "Gimp"           --> doFloat
    , className =? "spotify"           --> doFloat
    , title =? "Plover"           --> doFloat
    , title =? "Extension: (Plug) - Plug Notification — Mozilla Firefox"           --> doFloat
    , className  =? "Thunderbird" --> doShift "9"
    , className  =? "Psensor" --> doShift "6"
    , className =? "Firefox" <&&> resource =? "Toolkit" --> doFloat -- firefox pip
    -- , className =? "Firefox" <&&> resource =? "Popup" --> doFloat -- firefox pip
    , className =? "proton-bridge"           --> doShift "9"
    , className  =? "Synapse" --> hasBorder False
    , resource  =? "desktoxp_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ] <+> namedScratchpadManageHook scratchpads

------------------------------------------------------------------------
-- scratchpads
------------------------------------------------------------------------

scratchpads :: [NamedScratchpad]
scratchpads = [ 
    NS "terminal" spawnTerm findTerm manageTerm,
    -- first string class, second string className
    NS "ranger" "alacritty --class fileExplorer -e ranger" (resource =? "fileExplorer") manageTerm,
    -- NS "plover" "alacritty --name plover -e ~/plover-4.0.0.dev10-x86_64.AppImage --gui console" (resource =? "plover") ploverFloat,
    NS "bluetooth" "blueman-manager" (className =? "Blueman-manager") manageTerm,
    NS "spotify" "spotify" (className =? "Spotify") manageTerm,
    NS "todoList" "superproductivity" (className  =? "superProductivity")
          (customFloating $ W.RationalRect (1/3) (1/6) (1/3) (2/3)), 
    NS "nixnote" "nixnote2" (className =? "nixnote2") nonFloating,
    NS "pavucontrol" "pavucontrol" (className  =? "Pavucontrol")
          (manageTerm) 
    ]
    where
    spawnTerm  = myTerminal ++  " --class scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)
    ploverFloat = customFloating $ W.RationalRect (11/13) (1/50) (1/8) (1/4)


------------------------------------------------------------------------
-- main
------------------------------------------------------------------------
main :: IO ()
-- main = xmonad $ ewmhFullscreen $ ewmh $ myConfig
main = xmonad 
  . ewmhFullscreen 
  . ewmh 
  -- Recall that the .cabal folder has to be added to the path in the shell. In this case the xmonad seems
  -- to be run outside the shell.
  . withEasySB (statusBarProp "/home/judemlim/.cabal/bin/xmobar -x 0" (pure myXmobarPP)) defToggleStrutsKey
  . withEasySB (statusBarProp "/home/judemlim/.cabal/bin/xmobar -x 1" (pure myXmobarPP)) defToggleStrutsKey
  $ myConfig
    where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)

myConfig = def
    { modMask = mod4Mask  -- Rebind Mod to the Super key
    , layoutHook = myLayout
    , manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
    , startupHook = myStartupHook
    , focusedBorderColor = myFocusedBorderColor
    , borderWidth        = myBorderWidth
    }
  `additionalKeysP` myKeys
    -- Bonus ideas
    -- [ ("M-S-z", spawn "xscreensaver-command -lock")
    -- , ("M-S-=", unGrab *> spawn "scrot -s"        )
    -- , ("M-]"  , spawn "firefox"                   )
    -- ]

------------------------------------------------------------------------
-- layout
------------------------------------------------------------------------
-- using toggleStruts with monocle
myLayout = smartBorders $ avoidStruts $ uniformColumns ||| uniformMagnifiedColumns ||| columns ||| tiled ||| noBorders full ||| grid ||| centeredGrid ||| bsp 
  where
     -- default tiling algorithm partitions the screen into two panes
     -- TODO find out what layout with Hints placement does
     tiled = renamed [Replace "tall"] $ layoutHintsWithPlacement (1.0, 0.0) (spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $ ResizableTall 1 (3/100) (1/2) [])

     -- columns
     -- columns = renamed [Replace "columns"] $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ magnifiercz' 1.1 $ reflectHoriz $ ThreeColMid 1 (3/100) (1/2)
     columns = renamed [Replace "columns"] $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $ ThreeColMid 1 (3/100) (1/2)

     -- columns
     uniformColumns = renamed [Replace "uniform"] $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $ multiCol [1] 1 0.01 (-0.5)

     -- columns
     uniformMagnifiedColumns = renamed [Replace "magnifiedUniform"] $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $ magnifiercz' 1.4 $  multiCol [1] 1 0.01 (-0.5)

     -- grid
     grid = renamed [Replace "grid"] $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $  Grid (16/10)

     -- centered grid
     centeredGrid = renamed [Replace "centeredGrid"] $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $  centerMaster $ Grid (16/10)

     -- full
     full = renamed [Replace "full"] $ smartBorders (Full)

     -- bsp
     bsp = renamed [Replace "bsp"] $ reflectHoriz $ emptyBSP

     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

-- myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
--   where
--     threeCol = ThreeColMid nmaster delta ratio
--     -- threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
--     tiled    = Tall nmaster delta ratio
--     nmaster  = 1      -- Default number of windows in the master pane
--     ratio    = 1/2    -- Default proportion of screen occupied by master pane
--     delta    = 3/100  -- Percent of screen to increment by when resizing panes

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
------------------------------------------------------------------------
myKeys =
    [("M-v", windows copyToAll)   -- copy window to all workspaces
     , ("M-z", killAllOtherCopies)  -- kill copies of window on other workspaces
     , ("M-<Right>", moveTo Next $ Not emptyWS)
     , ("M-<Left>", moveTo Prev $ Not emptyWS)
     , ("M-S-r", spawn rangerTerminal)
     , ("M-S-a", sendMessage MirrorExpand)
     , ("M-S-z", sendMessage MirrorShrink)
     , ("M-h", sendMessage Expand)
     , ("M-l", sendMessage Shrink)
     , ("M-s", sendMessage ToggleStruts)
     , ("M-f", sendMessage $ JumpToLayout "full")
     , ("M-u", sendMessage $ JumpToLayout "uniform")
     , ("M-c", sendMessage $ JumpToLayout "columns")
     , ("M-t", sendMessage $ JumpToLayout "tall")
     , ("M-g", sendMessage $ JumpToLayout "grid")
     , ("M-S-g", sendMessage $ JumpToLayout "centeredGrid")
     , ("M-b", sendMessage $ JumpToLayout "bsp")
     , ("M-/", withFocused $ windows . W.sink)
     --, ("M-n", refresh)
     , ("M-<Backspace>", windows W.swapMaster)
     , ("M-S-<Backspace>", spawn myTerminal)
     , ("M-C-<Return>", namedScratchpadAction scratchpads "terminal")
     , ("M-C-<Backspace>", namedScratchpadAction scratchpads "terminal")
     , ("M-C-r", namedScratchpadAction scratchpads "ranger")
     , ("M-C-m", namedScratchpadAction scratchpads "spotify")
     , ("M-C-z", namedScratchpadAction scratchpads "todoList")
     , ("M-C-n", namedScratchpadAction scratchpads "nixnote")
     , ("M-C-a", namedScratchpadAction scratchpads "pavucontrol")
     , ("M-C-b", namedScratchpadAction scratchpads "bluetooth")
     , ("M-C-p", namedScratchpadAction scratchpads "plover")
     , ("Print", spawn "gnome-screenshot")
     , ("M-p", spawn "rofi -show drun")
     , ("M-o", spawn "rofi -show drun -run-shell-command 'alacritty -e zsh -ic \"{cmd} && read\"'")
     -- Pneumonic is 'all'
     , ("M-a", spawn "rofi -show window")
     , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
     , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
     , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    ]
    where
    rangerTerminal = myTerminal ++ " -e ranger"

------------------------------------------------------------------------
-- Xmobar feed
------------------------------------------------------------------------

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    -- , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2 -- This seems to be breaking for some reason
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
