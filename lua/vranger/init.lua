local pipe = require 'vranger.pipe'
local commands = require 'vranger.commands'

local uv = vim.uv

local M = {}

-- Python integration script for ranger
local PYTHON_INTEGRATION = vim.api.nvim_get_runtime_file('python/nvim_ranger.py', false)[1]

-- Argument for ranger to run the integration script
local RANGER_CMDARG = ('--cmd=eval exec(open(%q).read())'):format(PYTHON_INTEGRATION)

local function read_callback(err, data)
    -- EOF?
    if err ~= nil or data == nil then return end

    if data:byte(1) == 0 then
        for cmd, arg in data:gmatch('%z(.)(.*)%z') do
            local cmd = cmd:byte(1)
            commands.schedule_execute(cmd, arg)
        end
    end
end

local DEFAULT_OPTIONS = {
    commands = true,

    ranger = {
        executable = 'ranger',
        bindings = {},
        extra_args = {},
    }
}

local OPTIONS = DEFAULT_OPTIONS

function M.open(dir, mods)
    local cmd

    if mods == '' then
        cmd = 'enew'
    else
        cmd = mods .. ' new'
    end

    vim.cmd(cmd)

    local buf = vim.fn.bufnr()

    vim.api.nvim_create_autocmd('BufEnter', {
        buffer = buf,
        command = 'startinsert',
    })

    local pipe = pipe.new(read_callback)
    local pp = pipe:write_path()

    local binds = {}
    for k, v in pairs(OPTIONS.ranger.bindings) do
        table.extend(binds, string.format('--cmd=map %s %s', k, v))
    end

    local cmd = {
        OPTIONS.ranger.executable,
        RANGER_CMDARG,
        '--cmd=map l nvim_open',
        '--cmd=map <c-j> nvim_open',
        '--cmd=map <right> nvim_open',
        unpack(binds),
        unpack(OPTIONS.ranger.extra_args),
    }

    if dir ~= nil then
        table.insert(cmd, vim.fs.normalize(dir))
    end

    vim.fn.termopen(cmd, {
        env = { ['NVIM_PIPE_PATH'] = pp },
        on_exit = function()
            pipe:close()
            vim.cmd(buf .. 'bd')
        end
    })
end

local function cmd_ranger(args)
    M.open(args.args, args.mods)
end

local function create_commands(opts)
    vim.api.nvim_create_user_command('Ranger', cmd_ranger, { nargs = '?' })
end

function M.setup(opts)
    OPTIONS = vim.tbl_deep_extend('force', DEFAULT_OPTIONS, opts)

    if OPTIONS.commands == true then
        create_commands(opts)
    end
end

return M
