-- HashCollision 08/03/22

local Module = {}

local Discordia = require('discordia')
local CommandMap = require('commands/meta').CommandMap

local Luv = require('uv')
--local Thread = require('thread')
local Parser = require('parser')
local Config = require('config')

-- Return token from 'secret' file
local function ReadToken()
    local Token = Config.readFile(Config.token_path)

    return Token
end

-- Invoked when the bot is logged in & ready
local function OnLogin()
    print('Logged in successfully!')
end

-- Invoked when a user sends a message the bot can see
local function OnMessageSent(Message)
    if Message.author.bot then return end

    local Arguments, Flags = Parser.parseCommand(Message.content)

    local CommandName = Arguments[1]
    local Command = CommandMap[CommandName]

    if CommandName and Command then
        local Success, Result = pcall(Command.run, Arguments, Flags, Message)

        if not Success then
            Message:reply(Result)
        end
    end
end

-- Start the bot, register it, etc.
function Module.start()
    local Bot = Discordia.Client()

    -- Events
    Bot:on('ready', OnLogin)
    Bot:on('messageCreate', OnMessageSent)

    -- Log em in
    local Token = ReadToken()

    Bot:run(Config.token_format:format(Token))
end

-- Stop the bot and clean it up
function Module.stop()
    os.exit()
end

return Module