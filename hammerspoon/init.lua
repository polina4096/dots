-- Cmd+Enter: open a new Ghostty terminal window (centered on the current space).
hs.hotkey.bind({"cmd"}, "return", function()
  local before = {}
  local app = hs.application.get("com.mitchellh.ghostty")
  if app then
    for _, w in ipairs(app:allWindows()) do before[w:id()] = true end
  end

  hs.task.new("/Applications/Ghostty.app/Contents/MacOS/ghostty", nil):start()

  -- Wait for the new window and center it.
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
        w:centerOnScreen()
        return
      end
    end
  end, 0.05)
end)

-- Instant CapsLock language switch.
-- CapsLock is remapped to F18 via hidutil; this catches F18 and cycles input sources.
hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  if event:getKeyCode() == 79 then -- F18
    local layouts = hs.keycodes.layouts(true)
    local current = hs.keycodes.currentSourceID()
    local idx
    for i, v in ipairs(layouts) do
      if v == current then idx = i break end
    end
    if idx then
      hs.keycodes.currentSourceID(layouts[idx % #layouts + 1])
    end
    return true
  end
end):start()
