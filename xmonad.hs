import XMonad;
import XMonad.Actions.CycleWS;
import XMonad.Actions.Submap;
import XMonad.Layout.Simplest;
import XMonad.Layout.SubLayouts;
import XMonad.Layout.Tabbed;

import qualified XMonad.Layout.BoringWindows as BW;
import qualified XMonad.StackSet             as W;
import qualified Data.Map                    as M;

import Control.Concurrent;
import System.Process;

main = xmonad $ defaultConfig {
  -- basics
  borderWidth        = 1,
  terminal           = "urxvt -sr",
  normalBorderColor  = "#666666",
  focusedBorderColor = "#FFFFFF",
  modMask            = mod4Mask,

  layoutHook = addTabsAlways shrinkText defaultTheme $ subLayout [] Simplest $ BW.boringWindows $ Tall 1 (1/40) (3/4),

  startupHook = liftIO $ createProcess (proc "/usr/bin/xscreensaver" []) >> return (),

  -- bindings
  keys = \ cfg@(XConfig {XMonad.modMask = modm}) -> M.fromList [
    ((modm,               xK_Return      ), spawn (XMonad.terminal cfg)),
    ((modm .|. shiftMask, xK_Return      ), spawn "x=`dmenu_path | dmenu` && eval \"exec $x\""),
    ((modm,               xK_bracketright), windows W.focusDown),
    ((modm,               xK_bracketleft ), windows W.focusUp),
    ((modm,               xK_backslash   ), windows W.focusMaster),
    ((modm .|. ctrlMask,  xK_bracketright), windows W.swapDown),
    ((modm .|. ctrlMask,  xK_bracketleft ), windows W.swapUp),
    ((modm .|. ctrlMask,  xK_backslash   ), windows W.swapMaster),
    ((modm .|. shiftMask, xK_bracketright), BW.focusDown),
    ((modm .|. shiftMask, xK_bracketleft ), BW.focusUp),
    ((modm,               xK_x           ), submap . M.fromList $ [
      ((0,                xK_bracketright), withFocused (sendMessage . mergeDir W.focusDown')),
      ((0,                xK_bracketleft ), withFocused (sendMessage . mergeDir W.focusUp')),
      ((0,                xK_backslash   ), withFocused (sendMessage . UnMerge))]),
    ((modm,               xK_BackSpace   ), withFocused (windows . ($ W.RationalRect (1/3) (1/3) (1/3) (1/3)) . W.float)),
    ((modm .|. shiftMask, xK_BackSpace   ), withFocused (windows . W.sink)),
    ((modm,               xK_period      ), sendMessage Expand),
    ((modm,               xK_comma       ), sendMessage Shrink),
    ((modm .|. ctrlMask,  xK_period      ), sendMessage (IncMasterN 1)),
    ((modm .|. ctrlMask,  xK_comma       ), sendMessage (IncMasterN (-1))),
    ((modm,               xK_Next        ), nextWS),
    ((modm,               xK_Prior       ), prevWS),
    ((modm .|. ctrlMask,  xK_Next        ), shiftToNext),
    ((modm .|. ctrlMask,  xK_Prior       ), shiftToPrev)
  ]
};

ctrlMask = controlMask; -- Brevity! Huzzah!
