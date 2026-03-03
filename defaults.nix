{ ... }: {
  system.primaryUser = "polina4096";

  # Disable "Are you sure you want to open this file?" security prompt.
  system.defaults.LaunchServices.LSQuarantine = false;

  system.defaults.NSGlobalDomain = {
    # Enable touchpad swipe gestures.
    AppleEnableMouseSwipeNavigateWithScrolls = true;
    AppleEnableSwipeNavigateWithScrolls = true;

    # Enable key press repeat.
    ApplePressAndHoldEnabled = false;

    # Show hidden files.
    AppleShowAllFiles = true;
    AppleShowAllExtensions = true;

    # Disable font feathering.
    AppleFontSmoothing = 0;

    # Show scrollbars only when scrolling.
    AppleShowScrollBars = "WhenScrolling";

    # Disable automatic typing correction.
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;

    # Drag windows with mouse.
    NSWindowShouldDragOnGesture = true;

    # Disable iCloud as the default save location.
    NSDocumentSaveNewDocumentsToCloud = false;

    # Better save dialog defaults.
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;

    # Keyboard repeat settings.
    InitialKeyRepeat = 10;
    KeyRepeat = 1;

    # Enable tab focus in "Do you want to save" dialog.
    AppleKeyboardUIMode = 3;

    # Sheet animation time.
    NSWindowResizeTime = 0.1;

    # Use fn for function keys.
    "com.apple.keyboard.fnState" = false;
  };

  # Disable dumb protections.
  networking.applicationFirewall.allowSigned = true;
  networking.applicationFirewall.allowSignedApp = true;

  # Dock settings.
  system.defaults.dock = {
    mru-spaces = false;
    orientation = "bottom";
    show-recents = false;
    tilesize = 64;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  # Finder settings.
  system.defaults.finder = {
    FXDefaultSearchScope = "SCcf";
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "Nlsv";
    ShowPathbar = true;
    ShowStatusBar = true;
  };

  system.defaults.CustomUserPreferences = {
    NSGlobalDomain = {
      # Disable language indicator.
      TSMLanguageIndicatorEnabled = 0;

      # Disable Quick Look animations.
      QLPanelAnimationDuration = 0;

      # Disable window animations.
      NSAutomaticWindowAnimationsEnabled = 0;

      # Enable WebKit developer extras.
      WebKitDeveloperExtras = true;

      # Disable shake mouse pointer to locate.
      CGDisableCursorLocationMagnification = true;

      # Double-click title bar to fill (new snapping).
      AppleActionOnDoubleClick = "Fill";
    };

    # More dock settings.
    "com.apple.dock" = {
      autohide = true;
      autohide-delay = 0.25;
      autohide-time-modifier = 0.5;
      size-immutable = true;
      no-bouncing = true;
    };

    # Keep various stores clean from .DS_Store files.
    "com.apple.desktopservices" = {
      DSDontWriteUSBStores = true;
      DSDontWriteNetworkStores = true;
    };

    # Better bluetooth audio.
    "com.apple.BluetoothAudioAgent" = {
      # From https://github.com/joeyhoer/starter/blob/master/system/bluetooth.sh
      "Apple Bitpool Max (editable)" = 80;
      "Apple Bitpool Min (editable)" = 48;
      "Apple Initial Bitpool (editable)" = 40;
      "Negotiated Bitpool" = 48;
      "Negotiated Bitpool Max" = 53;
      "Negotiated Bitpool Min" = 48;
      "Stream - Flush Ring on Packet Drop (editable)" = 30;
      "Stream - Max Outstanding Packets (editable)" = 15;
      "Stream Resume Delay" = "0.75";
    };

    # Skip unneeded checks.
    "com.apple.frameworks.diskimages" = {
      skip-verify = true;
      skip-verify-locked = true;
      skip-verify-remote = true;
    };

    # Less intrusive crash reporter.
    "com.apple.CrashReporter".UseUNC = 1;

    # Improve help viewer UX by making it a window.
    "com.apple.helpviewer".DevMode = true;

    # Activity monitor tweaks.
    "com.apple.ActivityMonitor" = {
      ShowCategory = 0;
    };

  };

  # Disable tiled windows margins.
  system.defaults.WindowManager.EnableTiledWindowMargins = false;

  # Energy Mode: High Power on battery and power adapter.
  # Values: 0 = Automatic, 1 = Low Power, 2 = High Power.
  system.activationScripts.postActivation.text = ''
    pmset -b lowpowermode 2
    pmset -c lowpowermode 2
    pmset -b lessbright 0

    # Disable True Tone.
    userUID=$(dscl . -read /Users/polina4096 GeneratedUID | awk '{print $2}')
    /usr/libexec/PlistBuddy -c "Set :CBUser-''${userUID}:CBColorAdaptationEnabled 0" \
      /private/var/root/Library/Preferences/com.apple.CoreBrightness.plist 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :CBUser-''${userUID}:CBColorAdaptationEnabled integer 0" \
      /private/var/root/Library/Preferences/com.apple.CoreBrightness.plist
    killall cfprefsd 2>/dev/null
    killall corebrightnessd 2>/dev/null

    # Remap CapsLock to F18 (used by Hammerspoon for language switching).
    /usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}' > /dev/null

    # Check if Hammerspoon is installed (needed for CapsLock language switch).
    if [ ! -d /Applications/Hammerspoon.app ] && [ ! -d "$HOME/Applications/Hammerspoon.app" ]; then
      echo "WARNING: Hammerspoon is not installed. Install it from https://github.com/Hammerspoon/hammerspoon/releases" >&2
    fi

    # Symlink Hammerspoon config.
    mkdir -p /Users/polina4096/.hammerspoon
    ln -sf ${./hammerspoon/init.lua} /Users/polina4096/.hammerspoon/init.lua
  '';
}
