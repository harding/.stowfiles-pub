import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat ]

-- 1: 21
-- 2: Bitcoin
-- 3: Personal
-- 4: Temp
-- 5: Apps
-- 6:
-- 7:
-- 8: Servers
-- 9: Swap
myWorkspaces = ["1A","2B","3C","4tmp","5app","6","7","8srv","9swp"]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/harding/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook
                <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask  -- rebind Mod to the Windows key
        , terminal           = "urxvtcd"
        , borderWidth        = 2
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#cd8b00"
        , workspaces = myWorkspaces
        }

-- , terminal           = "stterm -f 'Liberation Mono:size=14'"
