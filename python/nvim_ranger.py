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
    class nvim_cmd(Command):
        """
        :nvim_cmd <cmd> <args...>

        [Development Command] Sends the specified command to Neovim.
        """

        def execute(self):
            import struct

            cmd = struct.pack('B', int(self.arg(1)))
            arg = self.rest(2).encode('utf-8')

            NVIM_PIPE_FILE.write(b'\0' + cmd + arg + b'\0')

    class nvim_msg(Command):
        """
        :nvim_msg <message>

        Prints message in Neovim.
        """

        def execute(self):
            message = self.rest(1)
            NVIM_PIPE_FILE.write(b'\0\0' + message.encode('utf-8') + b'\0')

    class nvim_open(Command):
        """
        :nvim_open [modifier]

        Opens the selected file in Neovim. Modifiers: sp[lit], vs[plit], tab
        """

        def match_cmd(self, arg, name, len):
            return arg.startswith(name[:len]) and (name[len:]).startswith(arg[len:])

        def execute(self):
            arg = self.arg(1)

            command = b'\x01'

            if self.match_cmd(arg, 'split', 2):
                command = b'\x02'
            elif self.match_cmd(arg, 'vsplit', 2):
                command = b'\x03'
            elif self.match_cmd(arg, 'tab', 3):
                command = b'\x04'

            file = self.fm.thisfile
            if file.is_file and not file.is_binary():
                NVIM_PIPE_FILE.write(b'\0' + command + str(file).encode('utf-8') + b'\0')
            else:
                self.fm.move(right=1)


fm.commands.load_commands_from_module(CommandModule)
