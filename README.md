# vranger - Rich Ranger Integration for Neovim

This plugin utilizes Neovim's APIs to integrate cleanly and asynchronously with the Ranger file
browser. It includes a Python script that allows adding neovim-specific commands to Ranger which
communicate back to Neovim via a basic IPC mechanism.

`vranger` can be used as a drop-in for netrw's local browsing functionality

## Installation

### lazy.nvim

```lua
{ 'LunarLambda/nvim-vranger', opts = {} }
```

### Manual

Add the plugin to your runtime path and run the following Lua code:

```lua
require('vranger').setup(opts)
```

## Configuration

Defaults:

```lua
{
    -- Register ex commands (:Ranger)
    commands = true,

    -- Replace netrw as local file browser
    -- true disables netrw entirely
    -- 'local' allows using netrw for network browsing
    replace_netrw = false,

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

[^1]: Won't open binary files and falls back to Ranger's default behaviour instead.
