import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Wallpaper
import XMonad.Actions.Volume
import XMonad.Util.Dzen
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace
import qualified XMonad.StackSet as StackSet
    
-- The main function.
main = xmonad . ewmh =<< statusBar myBar myPP toggleStrutsKey
       (myConfig `additionalKeysP`
                     -- Rotate screen buttons
                     [ ("<XF86TaskPane>", spawn "/usr/local/bin/rotate_swap.sh")
                     , ("<XF86RotateWindows>", spawn "/usr/local/bin/rotate_orientation.sh")
                     --take a screenshot of entire display
                     , ("<Print>", spawn "scrot $HOME/Pictures/Screenshots/screen_%Y-%m-%d-%H-%M-%S.png -d 1")
                     --take a screenshot of focused window
                     , ("M-<Print>", spawn "scrot $HOME/Pictures/Screenshots/window_%Y-%m-%d-%H-%M-%S.png -d 1-u")
                     -- Volume buttons
                     , ("<XF86AudioLowerVolume>", (fmap round (lowerVolume 3)) >>= alert)
                     , ("<XF86AudioRaiseVolume>", (fmap round (raiseVolume 3)) >>= alert)
                     , ("<XF86AudioMute>", (fmap (\m -> if m then "On" else "Off") toggleMute) >>= alertString)
                     , ("<XF86Launch1>", (return "1") >>= alertString)
                     , ("M-e", spawn "$HOME/Sources/emacs/emacs/src/emacs")
                     , ("<XF86ScreenSaver>", spawn "i3lock -f -i $HOME/Pictures/Backgrounds/Godafoss_Iceland.png")
                     , ("M-<Right>", XMonad.windows StackSet.focusDown)
                     , ("M-<Left>", XMonad.windows StackSet.focusUp)
                     , ("M-S-<Right>", XMonad.windows StackSet.swapDown)
                     , ("M-S-<Left>", XMonad.windows StackSet.swapUp)
                     ])


-- Command to launch the bar.
myBar = "$HOME/.cabal/bin/xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- notification functions with Dzen
--alert = dzenConfig return . show
alertString = dzenConfig centered
alert = dzenConfig centered . show        
centered =
        onCurr (center 150 66)
    >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
    >=> addArgs ["-fg", "#80c0ff"]
    >=> addArgs ["-bg", "#2B2B2B"]

myConfig = defaultConfig
    { modMask = mod4Mask -- Use Super instead of Alt
--    , terminal = "gnome-terminal"
--    , terminal = "mlterm"
    , terminal = "urxvt"
    , handleEventHook = fullscreenEventHook
--    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , layoutHook = myLayout
    , workspaces = myWorkspaces
    , borderWidth = 0
    , startupHook = spawn "~/.xmonad/autostart"
    }


-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myMainLayout = tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

-- chain onWorkspace to specify layout per workspace,
-- the last element of the chain is the default layout
-- for all not specified workspaces
myLayout = onWorkspace "1:term" simpleTabbed
           $ onWorkspace "4:chat" simpleTabbed
           $ myMainLayout
     
myWorkspaces = ["1:term", "2:emacs", "3:browser", "4:chat", "5:misc1", "6:misc2", "7:misc3", "8:misc4", "9:misc5"]
