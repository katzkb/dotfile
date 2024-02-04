local function mousePress(eventobj)

  if eventobj:getButtonState(4) then
    hs.eventtap.event.newKeyEvent({'cmd'}, ']', true):post()
    hs.eventtap.event.newKeyEvent({'cmd'}, ']', false):post()
  end

  if eventobj:getButtonState(3) then
    hs.eventtap.event.newKeyEvent({'cmd'}, '[', true):post()
    hs.eventtap.event.newKeyEvent({'cmd'}, '[', false):post()
  end

  return false
end

hs.eventtap.new({25}, mousePress):start()