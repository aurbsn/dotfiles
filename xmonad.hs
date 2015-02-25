import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad 
        $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen"]}
        $ defaultConfig
        { 
            manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig,
            layoutHook = smartBorders . avoidStruts . layoutHook $ defaultConfig,
            modMask = mod4Mask,
            focusFollowsMouse = False,
            terminal = "sakura",
            focusedBorderColor = "#0000ff",
            normalBorderColor = "#99ccff"
        } `additionalKeysP` theseKeys
            
theseKeys = 
    [
        ("M4-p", spawn "dmenu_run"),
        ("<XF86AudioRaiseVolume>", spawn "amixer set Master 1+"),
        ("<XF86AudioLowerVolume>", spawn "amixer set Master 1-")
    ]
