try:
    from sysconfig import _parse_makefile as parse_makefile
except ImportError:
    from distutils.sysconfig import parse_makefile
from functools import cached_property
import pathlib
import shlex


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
