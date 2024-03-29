-- Simulate mouse via keyboard

local modal = hs.hotkey.modal.new()
modal.label = require("labels").new('🐭 mouse mode')

prefix.bind('', 'm', function() modal:toggle() end)

function modal:toggle()
    if modal.enabled then
        modal:exit()
    else
        modal:enter()
    end
end

function modal:entered()
    modal.enabled = true
    modal.label:show()
end

function modal:exited()
    modal.enabled = false
    modal.label:hide()
end

modal:bind('', 'escape', function() modal:exit() end)
modal:bind('', 'space', function() modal:exit() end)

local DX = {-1, 0, 0, 1}
local DY = {0, 1, -1, 0}
-- left, down, up, right
local KEYS = {'s', 'd', 'e', 'f'}
-- local KEYS = {'b', 'n', 'p', 'f'}

-- ------------
-- move
-- ------------
local DELTA = 20
local SLOW_DELTA = 5
local FAST_DELTA = 100

local function moveMouse(dx, dy)
    local p = hs.mouse.getAbsolutePosition()
    p['x'] = p['x'] + dx
    p['y'] = p['y'] + dy
    hs.mouse.setAbsolutePosition(p)
end

for i = 1, 4 do
    local fn = hs.fnutils.partial(moveMouse, DX[i] * DELTA, DY[i] * DELTA)
    modal:bind('', KEYS[i], fn, nil, fn)
    local fnSlow = hs.fnutils.partial(moveMouse, DX[i] * SLOW_DELTA, DY[i] * SLOW_DELTA)
    modal:bind('cmd', KEYS[i], fnSlow, nil, fnSlow)
    local fnFast = hs.fnutils.partial(moveMouse, DX[i] * FAST_DELTA, DY[i] * FAST_DELTA)
    modal:bind('alt', KEYS[i], fnFast, nil, fnFast)
end

-- ------------
-- scroll
-- ------------
local SCROLL_DELTA = 100

local SDX = {1, 0, 0, -1}
local SDY = {0, -1, 1, 0}

local function scroll(dx, dy)
    local offset = {dx, dy}
    hs.eventtap.event.newScrollEvent(offset, {}):post()
end

for i = 1, 4 do
    local fn = hs.fnutils.partial(scroll, SDX[i] * SCROLL_DELTA, SDY[i] * SCROLL_DELTA)
    modal:bind('shift', KEYS[i], fn, nil, fn)
end

-- ------------
-- click
-- ------------

local function click(button)
    local p = hs.mouse.getAbsolutePosition()
    if button == 0 then
        hs.eventtap.leftClick(p)
    elseif button == 1 then
        hs.eventtap.rightClick(p)
    else
        hs.eventtap.middleClick(p)
    end
end

modal:bind('', 'j', hs.fnutils.partial(click, 0), nil, nil)
modal:bind('', 'k', hs.fnutils.partial(click, 1), nil, nil)
modal:bind('', 'i', hs.fnutils.partial(click, 2), nil, nil)