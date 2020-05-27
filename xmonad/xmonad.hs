-------------------------------------------------------------------------------
--                  __  ____  __                       _                     --
--                  \ \/ /  \/  | ___  _ __   __ _  __| |                    --
--                   \  /| |\/| |/ _ \| '_ \ / _` |/ _` |                    --
--                   /  \| |  | | (_) | | | | (_| | (_| |                    --
--                  /_/\_\_|  |_|\___/|_| |_|\__,_|\__,_|                    --
--                                                                           --
-------------------------------------------------------------------------------
-- Remember to credit original authors
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

------------------------------------------------------------------------
-- config
------------------------------------------------------------------------

myModMask       = mod4Mask  -- Sets modkey to super/windows key
myTerminal      = "urxvt"   -- Sets default terminal
myBorderWidth   = 4         -- Sets border width for windows
myNormalBorderColor = "#839496"
myFocusedBorderColor = "#bbc5ff"
myppCurrent = "#268BD2"
myppVisible = "#268BD2"
myppHidden = "#B58900"
myppHiddenNoWindows = "#93A1A1"
myppTitle = "#FDF6E3"
myppUrgent = "#DC322F"
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- Startup hook
------------------------------------------------------------------------

myStartupHook = do
      spawnOnce "unclutter --timeout 2 &"
      spawnOnce "picom &"  
      spawnOnce "albert &"  
      spawnOnce "thunderbird"  
      spawn "~/Scripts/refresh_wallpaper.sh"  

------------------------------------------------------------------------
-- Event hook
------------------------------------------------------------------------

myEventHook = hintsEventHook

------------------------------------------------------------------------
-- layout
------------------------------------------------------------------------
-- using toggleStruts with monocle
myLayout = avoidStruts (columns ||| tiled ||| full ||| grid ||| bsp)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled = renamed [Replace "tall"] $ layoutHintsWithPlacement (1.0, 0.0) (spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $ ResizableTall 1 (3/100) (1/2) [])

     -- columns
     columns = renamed [Replace "columns"] $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ reflectHoriz $ ThreeColMid 1 (3/100) (1/2)

     -- grid
     grid = renamed [Replace "grid"] $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True $ Grid (16/10)

     -- full
     full = renamed [Replace "full"] $ smartBorders (Full)

     -- bsp
     bsp = renamed [Replace "bsp"] $ emptyBSP

     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

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
    , className =? "Firefox" <&&> resource =? "Toolkit" --> doFloat -- firefox pip
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ] <+> namedScratchpadManageHook scratchpads
    

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
------------------------------------------------------------------------
myKeys =
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (myWorkspaces) (map show [1 :: Int ..])
        , (f, m) <- [(W.view, ""), (W.shift, "S-"), (copy, "S-C-")]]
    ++
    [("S-C-a", windows copyToAll)   -- copy window to all workspaces
     , ("S-M-t", withFocused $ windows . W.sink) -- flatten flaoting window to tiled
     , ("S-C-z", killAllOtherCopies)  -- kill copies of window on other workspaces
     , ("M-<Right>", moveTo Next NonEmptyWS)
     , ("M-<Left>", moveTo Prev NonEmptyWS)
     , ("M-S-a", sendMessage MirrorExpand)
     , ("M-S-z", sendMessage MirrorShrink)
     , ("M-h", sendMessage Expand)
     , ("M-l", sendMessage Shrink)
     , ("M-s", sendMessage ToggleStruts)
     , ("M-f", sendMessage $ JumpToLayout "full")
     , ("M-t", sendMessage $ JumpToLayout "tall")
     , ("M-g", sendMessage $ JumpToLayout "grid")
     , ("M-b", sendMessage $ JumpToLayout "bsp")
     , ("M-c", sendMessage $ JumpToLayout "columns")
     , ("M-w", goToSelected defaultGSConfig) -- show all windows
     , ("M-C-<Return>", namedScratchpadAction scratchpads "terminal")
     , ("M-C-r", namedScratchpadAction scratchpads "ranger")
     , ("M-C-m", namedScratchpadAction scratchpads "spotify")
     , ("M-C-z", namedScratchpadAction scratchpads "todoList")
     , ("M-e", spawn "albert toggle")
     , ("M-p", spawn "rofi -show combi -modi combi") -- rofi
    ]

------------------------------------------------------------------------
-- scratchpads
------------------------------------------------------------------------

scratchpads :: [NamedScratchpad]
scratchpads = [ 
    NS "terminal" spawnTerm findTerm manageTerm,
    NS "ranger" "urxvt -name fileExplorer -e ranger" (resource =? "fileExplorer") manageTerm,
    -- TODO fix spotify's float problem
    NS "spotify" "spotify" (className =? "Spotify") manageTerm,
    NS "todoList" "superproductivity" (className  =? "superProductivity") 
          (customFloating $ W.RationalRect (1/3) (1/6) (1/3) (2/3))
    ]
    where
    spawnTerm  = myTerminal ++  " -name scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)
    
------------------------------------------------------------------------
-- main
------------------------------------------------------------------------

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar -x 0 /home/judemlim/.config/xmobar/xmobarrc"
    xmonad $ ewmh desktopConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
        , startupHook        = myStartupHook
        , layoutHook         = myLayout
        , handleEventHook    = myEventHook <+>  handleEventHook desktopConfig
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , terminal           = myTerminal
        , modMask            = myModMask
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc x
                        , ppCurrent = xmobarColor myppCurrent "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor myppVisible ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor myppHidden "" . wrap "+" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindows ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor  myppTitle "" . shorten 80     -- Title of active window in xmobar
                        , ppSep =  "<fc=#586E75> | </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor  myppUrgent "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
                    } `additionalKeysP`         myKeys

------------------------------------------------------------------------
-- help
------------------------------------------------------------------------

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
