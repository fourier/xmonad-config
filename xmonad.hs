import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Wallpaper
import XMonad.Actions.Volume
import XMonad.Util.Dzen
import XMonad.Layout.Tabbed
    
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
    , terminal = "mlterm"
    , handleEventHook = fullscreenEventHook
--    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , layoutHook = simpleTabbed
    , borderWidth = 0
    , startupHook = spawn "~/.xmonad/autostart"
    }


--myWorkspaces = ["1:irc", "2:www", "3:music", "4:misc", "5:xbmc", "6:GIMP", "7:slideshow!", "8:foo()", "9:vbox"]
