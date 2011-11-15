{-# LANGUAGE TupleSections #-}

import XMonad hiding (spawn);
import XMonad.Actions.CycleWS;
import XMonad.Actions.Submap;
import XMonad.Hooks.ManageHelpers;
import XMonad.Layout.Simplest;
import XMonad.Layout.SubLayouts;
import XMonad.Layout.Tabbed;

import qualified XMonad.Layout.BoringWindows as BW;
import qualified XMonad.StackSet             as W;
import qualified Data.Map                    as M;

import Data.Monoid;
import Data.IORef;
import System.Posix.Process;
import System.Posix.Types;

main = newIORef ([] :: [(ProcessID, ManageHook)]) >>= \ sp_ref ->
       xmonad $ defaultConfig {
  -- basics
  borderWidth        = 1,
  terminal           = "urxvt",
  normalBorderColor  = "#666666",
  focusedBorderColor = "#FFFFFF",
  modMask            = mod4Mask,

  layoutHook = addTabsAlways shrinkText defaultTheme $ subLayout [] Simplest $ BW.boringWindows $ Tall 1 (1/40) (3/4),

  startupHook = spawn_ "/usr/bin/xscreensaver" [] >> return (),

  manageHook = pid >>= maybe idHook
               (\ p ->
                liftIO (readIORef sp_ref) >>*
                lookup p >>=
                maybe idHook ((>>) $ liftIO . modifyIORef sp_ref $ filter ((/= p) . fst))),

  -- bindings
  keys = \ cfg@(XConfig {XMonad.modMask = modm}) -> M.fromList [
    ((modm,               xK_space       ), spawn_ "urxvt" ["-sr"] >> return ()),
    ((modm,               xK_Return      ), spawn_ "dmenu_run" []  >> return ()),
    ((modm,               xK_b           ), spawn_ "surf" []       >> return ()),
    --((modm .|. shiftMask, xK_space       ), spawn_ "urxvt" ["-sr"] >>* (, liftX $ withFocused (sendMessage . mergeDir W.focusDown') >>= \ () -> return mempty) >>= liftIO . modifyIORef sp_ref . (:)),
    --((modm .|. shiftMask, xK_b           ), spawn_ "surf" [] >>* (, liftX $ withFocused (sendMessage . mergeDir W.focusDown') >>= \ () -> return mempty) >>= liftIO . modifyIORef sp_ref . (:)),
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
    ((modm,               xK_w           ), kill),
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

spawn :: MonadIO m => String -> [String] -> Maybe [(String, String)] -> m ProcessID;
spawn x argu environ = liftIO $ forkProcess $ uninstallSignalHandlers >> createSession >> executeFile x True argu environ;

spawn_ :: MonadIO m => String -> [String] -> m ProcessID;
spawn_ x argu = spawn x argu Nothing;

infixl 1 >>*;
f >>* g = f >>= return . g;
