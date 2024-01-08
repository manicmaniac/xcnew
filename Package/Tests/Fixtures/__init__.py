from functools import cached_property
import pathlib
import shlex

try:
    from distutils.sysconfig import parse_makefile
except ImportError:
    from sysconfig import _parse_makefile
    from tempfile import NamedTemporaryFile

    # https://github.com/python/cpython/blob/v3.11.7/Lib/distutils/sysconfig.py#L72
    def parse_makefile(fn, g=None):
        with open(fn, mode='rb') as src, NamedTemporaryFile() as dest:
            data = src.read()
            # `distutils.sysconfig.parse_makefile` understands escaped newlines
            # but `sysconfig._parse_makefile` does not.
            # The next line fills the gap by just replacing escaped newlines.
            dest.write(data.replace(b'\\\n', b' '))
            dest.seek(0)
            return _parse_makefile(dest.name, g)

_script_path = pathlib.Path(__file__)


class Makefile(object):
    def __init__(self):
        makefile_path = path('Makefile')
        self._vars = parse_makefile(makefile_path)

    def __getattr__(self, name):
        value = self._vars.get(name.upper(), None)
        if value is None:
            return super().__getattr__(name)
        return value

    @cached_property
    def xcnew_rpaths(self):
        ldflags = shlex.split(self.ldflags)
        rpath_indices = (i for i, f in enumerate(ldflags, 1) if f == '-rpath')
        return [ldflags[i] for i in rpath_indices]


def path(name):
    return _script_path.parent / name
