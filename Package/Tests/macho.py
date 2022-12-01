#!/usr/bin/env python3

import collections
import os
import struct

LC_REQ_DYLD = 0x80000000
LC_RPATH = 0x1c | LC_REQ_DYLD

Arch = collections.namedtuple('Arch', 'cputype cpusubtype rpaths')


class MachOBinary(object):
    """
    A class representing Mach-O binary format.
    This class is specialized to extract LC_RPATH load command entry.
    """

    def __init__(self, path):
        with open(path, 'rb') as f:
            self._file = f
            self._parse()

    def _parse(self):
        magic, = self._load('>I')
        if magic == 0xcafebabe:
            self._fat_header(32)
        elif magic == 0xcafebabf:
            self._fat_header(64)
        else:
            self._file.seek(-4, os.SEEK_CUR)
            mach = self._mach_magic()
            self.archs = [mach]

    def _fat_header(self, bits):
        nfat_archs, = self._load('>I')
        offset = self._file.tell()
        self.archs = [None] * nfat_archs
        for i in range(nfat_archs):
            self._file.seek(offset)
            self.archs[i] = self._fat_arch(bits)

    def _fat_arch(self, bits):
        cputype, cpusubtype = self._load('>II')
        if bits == 32:
            offset, size, align = self._load('>III')
        else:
            offset, size, align, reserved = self._load('>QQII')
        self._file.seek(offset)
        mach = self._mach_magic()
        return mach

    def _mach_magic(self):
        magic, = self._load('<I')
        if magic == 0xfeedface:
            return self._mach_header(32)
        elif magic == 0xfeedfacf:
            return self._mach_header(64)
        else:
            raise RuntimeError('Unknown magic %x' % magic)

    def _mach_header(self, bits):
        (cputype, cpusubtype, filetype,
         ncmds, sizeofcmds, flags) = self._load('<IIIIII')
        if bits == 64:
            self._load('<I')  # reserved
        load_commands = [None] * ncmds
        for i in range(ncmds):
            load_commands[i] = self._load_command()
        rpaths = [c for c in load_commands if c is not None]
        return Arch(cputype, cpusubtype, rpaths)

    def _load_command(self):
        cmd, cmdsize = self._load('<II')
        if cmd == LC_RPATH:
            return self._rpath_command(cmdsize)
        self._file.seek(cmdsize - 8, os.SEEK_CUR)

    def _rpath_command(self, cmdsize):
        offset, = self._load('<I')
        rpath = self._file.read(cmdsize - offset).rstrip(b'\0').decode('utf-8')
        return rpath

    def _load(self, format):
        size = struct.calcsize(format)
        return struct.unpack(format, self._file.read(size))


def get_rpaths(path):
    """
    Extract LC_RPATH entry from the given path.

    Since macOS 12, `objdump --no-leading-headers --macho --rpaths <PATH>`
    returns the same output.
    """
    return MachOBinary(path).archs[0].rpaths
