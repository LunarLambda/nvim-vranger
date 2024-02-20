# NOTE: This file is not a proper python module!
# File-relative imports will not work
# Use global declarations if you need global state of your commands
# Maybe I'll make a PR for ranger to add a proper module import command :P

import os
from ranger.api.commands import Command

global NVIM_PIPE_FILE

NVIM_PIPE = os.environ['NVIM_PIPE_PATH']
NVIM_PIPE_FILE = open(NVIM_PIPE, 'wb', 0)

class CommandModule:
    class nvim_hello(Command):
        def execute(self):
            NVIM_PIPE_FILE.write(b'\0\0hello neovim!\0')

fm.commands.load_commands_from_module(CommandModule)
