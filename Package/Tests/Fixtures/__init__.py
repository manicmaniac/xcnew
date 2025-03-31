from functools import cached_property
import pathlib
import re
import shlex


_script_path = pathlib.Path(__file__)


class Makefile(object):
    def __init__(self):
        makefile_path = path('Makefile')
        self._vars = _parse_makefile_vars(makefile_path)

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


_var_decl_re = re.compile(r'^\s*(\w+)\s*=\s*(.*?)\s*$')
_var_re = re.compile(r'\$\((\w+)\)')


# Parse very simple Makefile and returns declared variables.
def _parse_makefile_vars(path):
    with open(path) as f:
        text = f.read().replace('\\\n', '')
    vars = {}
    for line in text.splitlines():
        matched = _var_decl_re.search(line)
        if not matched:
            continue
        name = matched.group(1)
        value = matched.group(2)
        matched = _var_re.search(value)
        if matched:
            value = value.replace(matched.group(0), vars.get(matched.group(1), ''))
        vars[name] = value
    return vars
