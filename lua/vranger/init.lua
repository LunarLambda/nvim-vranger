local pipe = require 'vranger.pipe'
local uv = vim.uv

local M = {}

-- Python integration script for ranger
local PYTHON_INTEGRATION = vim.api.nvim_get_runtime_file('python/nvim_ranger.py', false)[1]

-- Argument for ranger to run the integration script
local RANGER_CMDARG = ('--cmd=eval exec(open(%q).read())'):format(PYTHON_INTEGRATION)

local COMMANDS = {
    [0] = print
}

local function read_callback(err, data)
    -- EOF?
    if data == nil then return end

    if data:byte(1) == 0 then
        for cmd, msg in data:gmatch('%z(.)(.*)%z') do
            local cmd = cmd:byte(1)
            if COMMANDS[cmd] then
                vim.schedule(function()
                    COMMANDS[cmd](msg)
                end)
            end
        end
    else
        -- select(files?|dir)
    end
end

function M.open(dir, mods)
    if mods == nil then
        mods = 'tab'
    end

    vim.cmd(mods .. ' new')

    local pipe = pipe.new(read_callback)
    local cmd = { 'ranger', RANGER_CMDARG }

    if dir ~= nil then
        table.insert(cmd, vim.fs.normalize(dir))
    end

    vim.fn.termopen(cmd, {
        env = { ['NVIM_PIPE_PATH'] = pipe:write_path() },
        on_exit = function()
            pipe:close()
        end
    })
end

local function cmd_ranger(args)
    M.open(args.args, args.mods)
end

function M.setup(opts)
    vim.api.nvim_create_user_command('Ranger', cmd_ranger, {
        nargs = '?',
    })
    -- todo: configs
end

return M
