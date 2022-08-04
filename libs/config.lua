-- HashCollision 08/03/22

local Filesystem = require('fs')
local Json = require('json')

local config_path = 'bot-config.json'

local file_error = 'Cannot %s %s, Error: %s'
local file_feedback = '(%s %s)'

-- List of fields allowed to be changed and stored in config json.
local writable_fields = {

    command_prefix = true,

}

local Config = {

    -- Prefix for calling commands, e.g: 'ag!play apocalyptica til death do us part'.
    command_prefix = 'ag!',

    -- Used to seperate regular command arguments, by default it's '%S+' to match all spaces.
    command_arg_seperator = '%S+',

    -- Format of the token given to discordia, %s = actual token
    -- Token spec: https://github.com/SinisterRectus/Discordia/wiki/Writing-Your-First-Bot
    token_format = 'Bot %s',

    -- Path of the token file
    token_path = '.SECRET',

}

-- Check existence of and return content of a given file, or raise errors.
function Config.readFile(FilePath)
    p(file_feedback:format('reading', FilePath))

    local DoesExist, Err = Filesystem.existsSync(FilePath)

    assert(not Err, file_error:format('check existence of', FilePath, Err))

    if DoesExist then
        local Text, Err = Filesystem.readFileSync(FilePath)

        assert(not Err, file_error:format('read', FilePath, Err))

        if Text then
            p(file_feedback:format('read', FilePath))

            return Text
        end
    end
end

-- Check existence of and write content to a given file, or raise errors.
function Config.writeFile(FilePath, NewContents)
    p(file_feedback:format('writing', FilePath))

    local DoesExist, Err = Filesystem.existsSync(FilePath)

    assert(not Err, file_error:format('check existence of', FilePath, Err))

    if DoesExist then
        local Text = Json.encode(NewContents)
        local Success, Err = Filesystem.writeFileSync(FilePath, Text)

        assert(Success, file_error:format('write', 'bot config json', Err))

        p(file_feedback:format('wrote', FilePath))
    end
end

-- Read the bot config json, and write writeable fields from it to the config file
function Config.readConfig()
    local Text = Config.readFile(config_path)
    local Contents = Json.decode(Text)

    for Name, Value in pairs(Contents) do
        if writable_fields[Name] then
            Config[Name] = Value
        end
    end
end

-- Write to the bot config json with writable fields
function Config.writeConfig()
    local NewContents = {}

    for Name in pairs(writable_fields) do
        NewContents[Name] = Config[Name]
    end

    Config.writeFile(config_path, NewContents)
end

Config.readConfig()

return Config