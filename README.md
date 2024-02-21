# vranger - Rich Ranger Integration for Neovim

WIP!

It:

1. Uses a python integration script to add neovim-specific commands to ranger
   without needing to touch the user's configuration files
2. Uses pipes to communicate with ranger directly and asynchronously

Features:

- [ ] Commands (:Ex and friends)
    - [x] :Ranger \[dir\] (subject to change)
- [ ] Netrw-dropin (FileExplorer autocmds)
- [x] Keybindings
- [x] Docs

## Installation

lazy.nvim:

```lua
{ 'LunarLambda/nvim-vranger', opts = {} }
```

Manual:

```lua
require('vranger').setup({...})
```

## Configuration

Defaults:

```lua
{
    -- Register ex commands (:Ranger)
    commands = true,

    ranger = {
        -- Name/path of ranger executable
        executable = 'ranger',

        -- Map of custom ranger bindings
        -- e.g. ['os'] = 'nvim_open split'
        bindings = {}

        -- Additional command line arguments passed to ranger
        extra_args = {}
    }
}
```

## Ranger Commands

Command                | Description
-----------------------|----------------------------
`nvim_msg <args...>`   | Print message inside Neovim
`nvim_open [modifier]` | Open selected file in Neovim [^1]. Modifiers are `sp[lit]`, `vs[plit]`, `tab`.

[^1]: Won't open binary files and fallback to Ranger's default behaviour instead.
