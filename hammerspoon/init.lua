-- Keep references to Hammerspoon objects to prevent garbage collection.
local _keep = {}
local function keep(it)
  _keep[#_keep + 1] = it
  return it
end

-- Disable window move animations.
hs.window.animationDuration = 0

-- Cmd+Enter: open a new Ghostty terminal window (centered on the current space).
keep(hs.hotkey.bind({ "cmd" }, "return", function()
  local app = hs.application.get("com.mitchellh.ghostty")
  if not app then
    hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")
    return
  end

  local targetSpace = hs.spaces.focusedSpace()
  local targetScreen = hs.mouse.getCurrentScreen()
  local before = {}
  local hasFullscreen = false
  for _, w in ipairs(app:allWindows()) do
    before[w:id()] = true
    if w:isFullScreen() then hasFullscreen = true end
  end

  hs.osascript.applescript([[tell application "Ghostty" to new window]])

  local function centerWindow(w)
    hs.spaces.moveWindowToSpace(w:id(), targetSpace)
    local sf = targetScreen:frame()
    local wf = w:frame()
    w:setFrame({
      x = sf.x + (sf.w - wf.w) / 2,
      y = sf.y + (sf.h - wf.h) / 2,
      w = wf.w,
      h = wf.h,
    })
    w:focus()
  end

  -- Wait for the new window, move it to the current space/screen, and center it.
  hs.timer.waitUntil(function()
    local a = hs.application.get("com.mitchellh.ghostty")
    if not a then return false end
    for _, w in ipairs(a:allWindows()) do
      if not before[w:id()] then return true end
    end
    return false
  end, function()
    local a = hs.application.get("com.mitchellh.ghostty")
    for _, w in ipairs(a:allWindows()) do
      if not before[w:id()] then
        if hasFullscreen then
          -- New window may inherit fullscreen. Give macOS a moment to
          -- apply the transition, then undo it if needed.
          hs.timer.doAfter(0.3, function()
            if w:isFullScreen() then
              w:setFullScreen(false)
              hs.timer.waitUntil(
                function() return not w:isFullScreen() end,
                function() centerWindow(w) end,
                0.05
              )
            else
              centerWindow(w)
            end
          end)
        else
          centerWindow(w)
        end
        return
      end
    end
  end, 0.01)
end))

-- Instant CapsLock language switch.
-- CapsLock is remapped to F18 via hidutil; this catches F18 and cycles input sources.
keep(hs.hotkey.bind({}, "f18", function()
  local layouts = hs.keycodes.layouts(true)
  local current = hs.keycodes.currentSourceID()
  local idx
  for i, v in ipairs(layouts) do
    if v == current then
      idx = i
      break
    end
  end
  if idx then
    hs.keycodes.currentSourceID(layouts[idx % #layouts + 1])
  end
end))
