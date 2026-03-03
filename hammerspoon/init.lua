-- Cmd+Enter: open a new Ghostty terminal window (on the current space).
hs.hotkey.bind({"cmd"}, "return", function()
  hs.task.new("/Applications/Ghostty.app/Contents/MacOS/ghostty", nil):start()
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
