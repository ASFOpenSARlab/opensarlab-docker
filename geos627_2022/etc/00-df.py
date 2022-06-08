"""
Magic commands to get file usage from python function shutil.disk_usage().
This magic is designed to work on a per line basis. Adding other commands in a cell may have unintended consequences.
`%df` returns a human readable string in GB. Input is the path to the disk/partition. Default is '/home/jovyan'.
`%df --raw` returns a raw data object.
`%df --on` returns rsults in a string in GB after every subsequent cell run.
`%df --off` turns off `on`.
`%df -p /` sets the path to the partition to check.
`%df -v` prints off additional text for debugging.
Examples:
    > %df
    Total storage: 493.01 GB. Storage used: 0.90 GB. Storage free: 492.10 GB
    ---
    > %df --raw -p /
    usage(total=21462233088, used=9864794112, free=11597438976)
    ---
    > a = %df --raw -p /
    > print(a)
    > print(a.used)
    usage(total=21462233088, used=9864552448, free=11597680640)
    9864552448
    ---
    > %df --on
    > print("Hello")
    Hello
    Total storage: 493.01 GB. Storage used: 0.90 GB. Storage free: 492.10 GB
    > %df --off
    > print("Hello")
    Hello
"""

import shutil

from IPython.core import magic_arguments
from IPython.core.magic import line_magic, Magics, magics_class, needs_local_scope

@magics_class
class DfMagics(Magics):

    def __init__(self, shell):
        super(DfMagics, self).__init__(shell=shell)
        self.ip = shell
        self.reset()

    def reset(self):
        self.verbose = False
        self.is_registered = False
        self.path = '/home/jovyan/'
        self.raw = False
        self.on = False
        self.off = False
        self.one_off = False

    @line_magic
    @magic_arguments.magic_arguments()
    @magic_arguments.argument('-h', '--help', action='store_true')
    @magic_arguments.argument('--on', action='store_true', help='Turn on persistent df. All the following cells will show the space usage for the partition until turned off.')
    @magic_arguments.argument('--off', action='store_true', help='Turn off persistent df')
    @magic_arguments.argument('-p', '--path', default='/home/jovyan', help='Sets the path to the partition to check')
    @magic_arguments.argument('--raw', action='store_true', help="Returns the raw data object.")
    @magic_arguments.argument('-v', '--verbose', action='store_true', help='Prints off additional text for debugging.')
    def df(self, line='', code=None):
        args = magic_arguments.parse_argstring(self.df, line)

        if args.help:
            print(__doc__)
            return

        try:
            self.verbose = args.verbose
            self.path = args.path
            self.raw = args.raw
            self.on = args.on
            self.off = args.off
            self.one_off = True

            return self.run()

        except Exception as e:
            if self.verbose:
                print(e)
                raise

    def run(self):
        try:
            if self.verbose:
                print("*******")
                print(f"Toggle on: {self.on}")
                print(f"Toggle off: {self.off}")
                print(f"Path: {self.path}")
                print(f"Registered: {self.is_registered}")
                print(f"Raw: {self.raw}")
                print(f"Verbose: {self.verbose}")
                print(f"Is one-off: {self.one_off}")

            if self.on:
                if self.verbose:
                    print("Toggled on...")
                self.is_registered = True

            elif self.off:
                if self.verbose:
                    print("Toggled off...")
                self.reset()

            else:
                if self.verbose:
                    print("Not toggled...")

            if self.is_registered or self.one_off:

                self.one_off = False

                try:
                    res = shutil.disk_usage(self.path)
                except FileNotFoundError as e:
                    print(e)
                    return

                if self.raw:
                    if self.verbose:
                        print("Returning raw data instead of human readable")
                    print(res)
                    return res

                else:
                    GB = 1.0/1024/1024/1024
                    message = f"Total storage: {res.total * GB:.2f} GB. Storage used: {res.used * GB:.2f} GB. Storage free: {res.free * GB:.2f} GB"
                    print(message)

            else:
                return None

        except Exception as e:
            if self.verbose:
                print(e)
            raise

ip = get_ipython()
dfm = DfMagics(ip)
ip.register_magics(dfm)
ip.events.register('post_run_cell', dfm.run)

del ip
del dfm