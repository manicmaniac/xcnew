#!/usr/bin/env python3

import os
import pathlib
import re
import shlex
import shutil
import subprocess
import tempfile
import unittest

import macho


_script_path = pathlib.Path(__file__)
_executable_path = _script_path.joinpath('../../Scripts/preinstall').resolve()
_fixtures_path = _script_path.joinpath('../Fixtures').resolve()
# Defined in ./Fixtures/Makefile
_xcnew_rpaths = [
    '/path with space/Xcode.app/Contents/Developer/../Frameworks',
    '/path with space/Xcode.app/Contents/Developer/../PlugIns',
    '/path with space/Xcode.app/Contents/Developer/../SharedFrameworks',
]


class PreinstallTest(unittest.TestCase):
    def setUp(self):
        self.maxDiff = None
        self._original_developer_dir = pathlib.Path(subprocess.check_output(
            ['xcode-select', '--print-path'],
            encoding='utf-8',
        ).rstrip())
        self._tmpdir_object = tempfile.TemporaryDirectory(prefix=' ')
        self._tmpdir = pathlib.Path(self._tmpdir_object.name)
        self._setup_installer_payload_dir()
        self._setup_developer_dir()

    def tearDown(self):
        self._tmpdir_object.cleanup()

    def test_preinstall(self):
        out, err, status = self._run_preinstall(
            DEVELOPER_DIR=self.xcode_developer_dir,
            INSTALLER_PAYLOAD_DIR=self.installer_payload_dir,
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
            DEVELOPER_DIR=self.command_line_tools_developer_dir,
            INSTALLER_PAYLOAD_DIR=self.installer_payload_dir,
        )
        self.assertEqual(out, '')
        self.assertIn('DEVELOPER_DIR', err)
        self.assertEqual(status, 1)
        self.assertListEqual(self._get_rpaths(), _xcnew_rpaths)

    def test_preinstall_when_not_running_in_installer(self):
        out, err, status = self._run_preinstall(
            DEVELOPER_DIR=self.xcode_developer_dir,
        )
        self.assertEqual(out, '')
        self.assertIn('INSTALLER_PAYLOAD_DIR', err)
        self.assertEqual(status, 1)
        self.assertListEqual(self._get_rpaths(), _xcnew_rpaths)

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
        return macho.get_rpaths(self.xcnew_path)

    def _setup_installer_payload_dir(self):
        self.installer_payload_dir = self._tmpdir / 'Payload'
        bin_dir = self.installer_payload_dir / 'usr/local/bin'
        bin_dir.mkdir(parents=True)
        self.xcnew_path = bin_dir / 'xcnew'
        shutil.copy(_fixtures_path / 'xcnew', self.xcnew_path)

    def _setup_developer_dir(self):
        self._setup_command_line_tools_developer_dir()
        self._setup_xcode_developer_dir()

    def _setup_command_line_tools_developer_dir(self):
        self.command_line_tools_developer_dir = self._tmpdir.joinpath(
                'Library/Developer/CommandLineTools')
        self.command_line_tools_developer_dir.mkdir(parents=True)

    def _setup_xcode_developer_dir(self):
        contents_dir = self._tmpdir / 'Applications/Xcode.app/Contents'
        self.xcode_developer_dir = contents_dir / 'Developer'
        bin_dir = self.xcode_developer_dir / 'usr/bin'
        bin_dir.mkdir(parents=True)
        with contents_dir.joinpath('Info.plist').open('w') as f:
            f.write('CFBundleIdentifier = "com.apple.dt.Xcode";\n')
        xcrun_path = bin_dir / 'xcrun'
        with xcrun_path.open('w') as f:
            f.write('#!/bin/sh\n')
            f.write('DEVELOPER_DIR={} "$@"'.format(
                shlex.quote(os.fspath(self._original_developer_dir))))
        xcrun_path.chmod(0o700)


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


def _get_xcode_version():
    out = subprocess.check_output(['xcodebuild', '-version'], encoding='utf-8')
    version_string = out.split()[1]
    return tuple(map(int, version_string.split('.')))


if __name__ == '__main__':
    unittest.main()
