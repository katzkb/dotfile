--[[
local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(200)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()      
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

local function disableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:disable()
   end
end

local function enableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:enable()
   end
end
--]]

local function handleGlobalAppEvent(name, event, app)
   -- if event == hs.application.watcher.activated then
      -- hs.alert.show(name)
      -- if name ~= "iTerm2" then
      --    enableAllHotkeys()
      -- else
      --    disableAllHotkeys()
      -- end
   -- end
end

local function keyCtrlK()
  keyCode('e', {'shift', 'ctrl'})()
  keyCode('x', {'cmd'})()
end
hs.hotkey.bind({'ctrl'}, 'k', keyCtrlK, nil, keyCtrlK)

appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
appsWatcher:start()

--[[
-- ===================================== -- 
-- コメントアウト部分は「英数かな.app」にて実現 --
-- ===================================== --

-- カーソル移動(Macなら標準でできるようになっている)
remapKey({'ctrl'}, 'f', keyCode('right')) -- 右
remapKey({'ctrl'}, 'b', keyCode('left')) -- 左
remapKey({'ctrl'}, 'n', keyCode('down')) -- 下
remapKey({'ctrl'}, 'p', keyCode('up')) -- 上

-- テキスト編集
remapKey({'ctrl'}, 'w', keyCode('x', {'cmd'})) -- 切り取り
remapKey({'alt'}, 'w', keyCode('c', {'cmd'})) -- コピー
remapKey({'ctrl'}, 'y', keyCode('v', {'cmd'})) -- 貼り付け
remapKey({'ctrl'}, 'm', keyCode('return')) -- 改行

-- コマンド
remapKey({'ctrl'}, 's', keyCode('f', {'cmd'})) -- 検索
remapKey({'ctrl'}, '/', keyCode('z', {'cmd'})) -- 元に戻す
remapKey({'ctrl', 'shift'}, '/', keyCode('z', {'cmd', 'shift'})) -- やり直し
remapKey({'ctrl'}, 'g', keyCode('escape'))
-- remapKey({'ctrl'}, 'x', keyCode('s', {'cmd'})) -- 保存(できない)


-- ページスクロール
remapKey({'ctrl'}, 'v', keyCode('pagedown'))
remapKey({'alt'}, 'v', keyCode('pageup'))
remapKey({'cmd', 'shift'}, ',', keyCode('home'))
remapKey({'cmd', 'shift'}, '.', keyCode('end'))

hs.hotkey.new({'ctrl'}, 'x', function() commandMode:enable() end)
--]]

JIS_LEFT_BRACKET_CODE = 30
JIS_RIGHT_BRACKET_CODE = 42

local function info(message)
    -- hs.alert.show(message)
end

local function getTableLength(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

local function isEqualTable(t1, t2)
    if getTableLength(t1) ~= getTableLength(t2) then return false end
    for k, v in pairs(t1) do
        if t2[k] ~= v then
            return false
        end
    end
    return true
end

local function disableAll(keySet)
    for k, v in pairs(keySet) do v:disable() end
end

local function enableAll(keySet)
    for k, v in pairs(keySet) do v:enable() end
end

local function pressKey(modifiers, key)
    modifiers = modifiers or {}
    hs.eventtap.keyStroke(modifiers, key, 20 * 1000)
end

local function pressKeyFunc(modifiers, key)
    return function() pressKey(modifiers, key) end
end

local function createKeyRemap(srcModifiers, srcKey, dstModifiers, dstKey)
    dstFunc = function() pressKey(dstModifiers, dstKey) end
    return hs.hotkey.new(srcModifiers, srcKey, dstFunc, nil, dstFunc)
end

SubMode = {}
SubMode.new = function(name, commandTable, othersFunc)
    local obj = {}
    obj.name = name
    obj.commandTable = commandTable
    obj.othersFunc = othersFunc
    obj.commandWatcher = {}
    obj.enable = function(self)
        info(self.name.." start")
        self.commandWatcher:start()
    end

    obj.disable = function(self)
        info(self.name.." end")
        self.commandWatcher:stop()
    end

    obj.commandWatcher = hs.eventtap.new( {hs.eventtap.event.types.keyDown},
        function(tapEvent)
            for k,v in pairs(obj.commandTable) do
                if v.key == hs.keycodes.map[tapEvent:getKeyCode()] and isEqualTable(v.modifiers, tapEvent:getFlags()) then
                    info(obj.name.." end")
                    obj.commandWatcher:stop()
                    if v.func then
                        v.func()
                    end
                    return true
                end
            end

            if obj.othersFunc then
                return othersFunc(tapEvent)
            end
        end)
    return obj
end


markMode = SubMode.new(
    "Mark Mode",
    {
        {modifiers = {ctrl = true}, key = 'space'}, -- only disables mark mode
        {modifiers = {ctrl = true}, key = 'g'}, -- only disables mark mode
        {modifiers = {ctrl = true}, key = 'w', func = pressKeyFunc({'cmd'}, 'x')}
        -- {modifiers = {alt = true},  key = 'w', func = pressKeyFunc({'cmd'}, 'c')}
    },

    function(tapEvent) -- force shift on
        flags = tapEvent:getFlags()
        flags.shift = true
        tapEvent:setFlags(flags)
        return false
    end
)

commandMode = SubMode.new(
    "Command Mode",
    {
        {modifiers = {ctrl = true}, key = 'g'}, -- only disables command mode
        {modifiers = {ctrl = true}, key = 'f', func = pressKeyFunc({'cmd', 'shift'}, 'o')},
        {modifiers = {ctrl = true}, key = 's', func = pressKeyFunc({'cmd'}, 's')},
        -- next tab
        {modifiers = {},            key = 'n', func = pressKeyFunc({'cmd', 'shift'}, JIS_RIGHT_BRACKET_CODE)},
        -- previous tab
        {modifiers = {},            key = 'p', func = pressKeyFunc({'cmd', 'shift'}, JIS_LEFT_BRACKET_CODE)},
        -- close tab
        {modifiers = {},            key = 'k', func = pressKeyFunc({'cmd'}, 'w')},
        {modifiers = {},            key = 'h', func = pressKeyFunc({'cmd'}, 'a')},
    }
)

xcodeBindings = {
    -- mark mode
    hs.hotkey.new({'ctrl'}, 'space', function() markMode:enable() end),
    -- command mode
    hs.hotkey.new({'ctrl'}, 'x', function() commandMode:enable() end),

    -- etc
    -- jump to beginning/end of document
    createKeyRemap({'alt', 'shift'}, ',', {'cmd'}, 'up'),
    createKeyRemap({'alt', 'shift'}, '.', {'cmd'}, 'down'),

    -- move to up/down of line. for popup window
    createKeyRemap({'ctrl'}, 'p', {}, 'up'),
    createKeyRemap({'ctrl'}, 'n', {}, 'down'),

    -- undo
    createKeyRemap({'ctrl'}, '/', {'cmd'}, 'z'),

    -- search
    createKeyRemap({'ctrl'}, 's', {'cmd'}, 'f'),

    -- paste
    createKeyRemap({'ctrl'}, 'y', {'cmd'}, 'v'),

    -- kill line
    hs.hotkey.new({'ctrl'}, 'k', function()
        markMode:enable()
        pressKey({'ctrl'}, 'e')
        pressKey({'ctrl'}, 'w')
    end),
}
--[[
hs.window.filter.new('Xcode')
    :subscribe(hs.window.filter.windowFocused,function() enableAll(xcodeBindings) end)
    :subscribe(hs.window.filter.windowUnfocused,function()
        disableAll(xcodeBindings)
        markMode:disable()
        commandMode:disable()
    end)
--]]


enableAll(xcodeBindings)

-- for debug

local function showKeyPress(tapEvent)
    local code = tapEvent:getKeyCode()
    local charactor = hs.keycodes.map[tapEvent:getKeyCode()]
    hs.alert.show(tostring(code)..":"..charactor, 1.5)
end

local keyTap = hs.eventtap.new( {hs.eventtap.event.types.keyDown}, showKeyPress)
-- keyTap = hs.eventtap.new( {hs.eventtap.event.types.keyDown}, showKeyPress)

k = hs.hotkey.modal.new({"cmd", "shift", "ctrl"}, 'P')

function k:entered()
    hs.alert.show("Enabling Keypress Show Mode", 1.5)
    keyTap:start()
end

function k:exited()
    hs.alert.show("Disabling Keypress Show Mode", 1.5)
end

k:bind({"cmd", "shift", "ctrl"}, 'P', function()
    keyTap:stop()
    k:exit()
end)