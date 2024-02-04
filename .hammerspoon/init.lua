inspect = hs.inspect.inspect
prefix = require("prefix")
utils = require("utils")

require("base")
require("double_cmdq_to_quit")
-- require("keymaps")
require("mouse_key")
-- require("window")
-- require("caffeinate")
-- require("url_dispatcher")
require("mouse_button")
eventListener = require("event_listener")
pcall(hs.fnutils.partial(require, "local"))

utils.tempNotify(3, hs.notify.new({
    title = "Hammerspoon",
    subTitle = "Config reloaded",
}))