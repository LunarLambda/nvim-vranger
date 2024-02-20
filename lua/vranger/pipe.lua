local uv = vim.uv

local M = {}

local Pipe = {}
Pipe.__index = Pipe

-- [OS dependent] format string for IPC-pipes
-- Could also use mkfifo w/ tmp path
local PIPEFMT = ('/proc/%d/fd/%%d'):format(vim.uv.os_getpid())

function M.new(read_callback)
    local fds = uv.pipe()
    local pipe = uv.new_pipe()
    pipe:open(fds.read)
    pipe:read_start(read_callback)

    return setmetatable({ read = pipe, write = fds.write }, Pipe)
end

function Pipe:close()
    uv.fs_close(self.write)
    self.read:close()
end

function Pipe:write_path()
    return PIPEFMT:format(self.write)
end

return M
