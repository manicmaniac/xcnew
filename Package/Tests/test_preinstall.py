#!/usr/bin/env python3

import os
import pathlib
import re
import shutil
import subprocess
import tempfile
import unittest

import Fixtures
import macho


_script_path = pathlib.Path(__file__)
_executable_path = _script_path.joinpath('../../Scripts/preinstall').resolve()


class PreinstallTest(unittest.TestCase):
    def setUp(self):
        self.maxDiff = None
        self._original_developer_dir = pathlib.Path(subprocess.check_output(
            ['xcode-select', '--print-path'],
            encoding='utf-8',
        ).rstrip())
        self._tmpdir_object = tempfile.TemporaryDirectory(prefix=' ')
        self._tmpdir = pathlib.Path(self._tmpdir_object.name)
        shutil.copytree(Fixtures.path('Container'),
                        self._tmpdir,
                        dirs_exist_ok=True)
        self._makefile = Fixtures.Makefile()

    def tearDown(self):
        self._tmpdir_object.cleanup()

    def test_preinstall(self):
        out, err, status = self._run_preinstall(
            DEVELOPER_DIR=self._xcode_developer_dir,
            INSTALLER_PAYLOAD_DIR=self._installer_payload_dir,
            ORIGINAL_DEVELOPER_DIR=self._original_developer_dir,
        )
        self.assertEqual(out, '')
        self.assertEqual(err, '')
        self.assertEqual(status, 0)
        expected_rpaths = [os.fspath(self._tmpdir / path) for path in (
            'Applications/Xcode.app/Contents/Developer/../Frameworks',
            'Applications/Xcode.app/Contents/Developer/../PlugIns',
            'Applications/Xcode.app/Contents/Developer/../SharedFrameworks',
        )]
        self.assertListEqual(self._get_rpaths(), expected_rpaths)

    def test_preinstall_when_developer_dir_is_not_in_xcode(self):
        out, err, status = self._run_preinstall(
            DEVELOPER_DIR=self._command_line_tools_developer_dir,
            INSTALLER_PAYLOAD_DIR=self._installer_payload_dir,
            ORIGINAL_DEVELOPER_DIR=self._original_developer_dir,
        )
        self.assertEqual(out, '')
        self.assertIn('DEVELOPER_DIR', err)
        self.assertEqual(status, 1)
        self.assertListEqual(self._get_rpaths(), self._makefile.xcnew_rpaths)

    def test_preinstall_when_not_running_in_installer(self):
        out, err, status = self._run_preinstall(
            DEVELOPER_DIR=self._xcode_developer_dir,
            ORIGINAL_DEVELOPER_DIR=self._original_developer_dir,
        )
        self.assertEqual(out, '')
        self.assertIn('INSTALLER_PAYLOAD_DIR', err)
        self.assertEqual(status, 1)
        self.assertListEqual(self._get_rpaths(), self._makefile.xcnew_rpaths)

    def _run_preinstall(self, **env):
        process = subprocess.Popen([],
                                   executable=_executable_path,
                                   cwd=self._tmpdir,
                                   env=env,
                                   encoding='utf-8',
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        out, err = process.communicate(timeout=20)
        err = _suppress_spam_warnings(err)
        return (out, err, process.returncode)

    def _get_rpaths(self):
        xcnew_path = self._tmpdir / self._makefile.installer_xcnew_path
        return macho.get_rpaths(xcnew_path)

    @property
    def _installer_payload_dir(self):
        return self._tmpdir / self._makefile.installer_payload_dir

    @property
    def _command_line_tools_developer_dir(self):
        return self._tmpdir / self._makefile.command_line_tools_developer_dir

    @property
    def _xcode_developer_dir(self):
        return self._tmpdir / self._makefile.xcode_developer_dir


_spam_warnings_re = re.compile(
    r'^.*Requested but did not find extension point with identifier ' +
    r'Xcode\.IDEKit\.Extension(SentinelHostApplications|' +
    r'PointIdentifierToBundleIdentifier) for extension ' +
    r'Xcode\.DebuggerFoundation\.AppExtension.*\.watchOS of plug-in .*$'
)


def _suppress_spam_warnings(string):
    if not ((13, 3) < _get_xcode_version() < (14,)):
        return string
    lines = []
    for line in string.splitlines():
        if _spam_warnings_re.search(line):
            continue
        lines.append(line)
    return '\n'.join(lines)


_xcode_version = None


def _get_xcode_version():
    global _xcode_version
    if _xcode_version is None:
        out = subprocess.check_output(['xcodebuild', '-version'],
                                      encoding='utf-8')
        version_string = out.split()[1]
        _xcode_version = tuple(map(int, version_string.split('.')))
    return _xcode_version


if __name__ == '__main__':
    unittest.main()
