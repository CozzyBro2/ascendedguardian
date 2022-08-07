local Module = {}

-- Aliases mapped to command names.
local CommandMap = {

    ping = require('./ping'),
    p = require('./ping'),

    voice = require('./vc'),
    vc = require('./vc'),
    v = require('./vc'),

}

Module.CommandMap = CommandMap

return Module