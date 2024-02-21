local M = {}

M.COMMANDS = {
    [0] = print,                -- nvim_msg
    [1] = vim.cmd.edit,         -- nvim_open
    [2] = vim.cmd.split,        -- nvim_open sp[lit]
    [3] = vim.cmd.vsplit,       -- nvim_open vs[plit]
    [4] = vim.cmd.tabedit,      -- nvim_open tab
}

function M.schedule_execute(cmd, arg)
    if M.COMMANDS[cmd] then
        vim.schedule(function() M.COMMANDS[cmd](arg) end)
    end
end

return M
