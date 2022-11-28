#!/usr/bin/env python3

import pathlib
import re
import shlex
import shutil
import subprocess
import tempfile
import unittest


class PreinstallTest(unittest.TestCase):
    script_path = pathlib.Path(__file__)
    executable_path = script_path.joinpath(
            '../../Scripts/preinstall').resolve()
    fixtures_path = script_path.joinpath('../Fixtures').resolve()

    def setUp(self):
        self.maxDiff = None
        self.original_developer_dir = pathlib.Path(subprocess.check_output(
            ['xcode-select', '--print-path'],
            encoding='utf-8',
        ).rstrip())
        self.tmpdir_object = tempfile.TemporaryDirectory()
        self.tmpdir = pathlib.Path(self.tmpdir_object.name)
        self.setup_installer_payload_dir()
        self.setup_developer_dir()

    def tearDown(self):
        self.tmpdir_object.cleanup()

    def test_preinstall(self):
        out, err, status = self.run_preinstall(self.xcode_developer_dir)
        self.assertEqual(out, '')
        self.assertEqual(err, '')
        self.assertEqual(status, 0)
        expected_rpaths = [str(self.tmpdir / path) for path in (
            'Applications/Xcode.app/Contents/Developer/../Frameworks',
            'Applications/Xcode.app/Contents/Developer/../PlugIns',
            'Applications/Xcode.app/Contents/Developer/../SharedFrameworks'
        )]
        self.assertListEqual(self.get_rpaths(), expected_rpaths)

    def test_preinstall_when_developer_dir_is_not_in_xcode(self):
        out, err, status = self.run_preinstall(
                self.command_line_tools_developer_dir)
        self.assertEqual(out, '')
        self.assertIn('Xcode', err)
        self.assertEqual(status, 1)
        expected_rpaths = [
            '/Applications/Xcode.app/Contents/Developer/../Frameworks',
            '/Applications/Xcode.app/Contents/Developer/../PlugIns',
            '/Applications/Xcode.app/Contents/Developer/../SharedFrameworks'
        ]
        self.assertListEqual(self.get_rpaths(), expected_rpaths)

    def run_preinstall(self, developer_dir):
        args = []
        env = {
            'DEVELOPER_DIR': developer_dir,
            'INSTALLER_PAYLOAD_DIR': self.installer_payload_dir,
        }
        process = subprocess.Popen(args,
                                   executable=self.executable_path,
                                   cwd=self.tmpdir,
                                   env=env,
                                   encoding='utf-8',
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        out, err = process.communicate(timeout=20)
        err = self.suppress_spam_warnings(err)
        return (out, err, process.returncode)

    def get_rpaths(self):
        args = ['objdump', '--no-leading-headers', '--macho', '--rpaths',
                self.xcnew_path]
        out = subprocess.check_output(args, encoding='utf-8')
        return out.rstrip().splitlines()

    def setup_installer_payload_dir(self):
        self.installer_payload_dir = self.tmpdir / 'Payload'
        bin_dir = self.installer_payload_dir / 'usr/local/bin'
        bin_dir.mkdir(parents=True)
        self.xcnew_path = bin_dir / 'xcnew'
        shutil.copy(self.fixtures_path / 'xcnew', self.xcnew_path)

    def setup_developer_dir(self):
        self.setup_command_line_tools_developer_dir()
        self.setup_xcode_developer_dir()

    def setup_command_line_tools_developer_dir(self):
        self.command_line_tools_developer_dir = self.tmpdir.joinpath(
                'Library/Developer/CommandLineTools')
        self.command_line_tools_developer_dir.mkdir(parents=True)

    def setup_xcode_developer_dir(self):
        contents_dir = self.tmpdir / 'Applications/Xcode.app/Contents'
        self.xcode_developer_dir = contents_dir / 'Developer'
        bin_dir = self.xcode_developer_dir / 'usr/bin'
        bin_dir.mkdir(parents=True)
        with contents_dir.joinpath('Info.plist').open('w') as f:
            f.write('CFBundleIdentifier = "com.apple.dt.Xcode";\n')
        xcrun_path = bin_dir / 'xcrun'
        with xcrun_path.open('w') as f:
            f.write('#!/bin/sh\n')
            f.write('DEVELOPER_DIR={} "$@"'.format(
                shlex.quote(str(self.original_developer_dir))))
        xcrun_path.chmod(0o700)

    _spam_warnings_re = re.compile(
        r'^.*Requested but did not find extension point with identifier ' +
        r'Xcode\.IDEKit\.Extension(SentinelHostApplications|' +
        r'PointIdentifierToBundleIdentifier) for extension ' +
        r'Xcode\.DebuggerFoundation\.AppExtension.*\.watchOS of plug-in .*$'
    )

    def suppress_spam_warnings(self, string):
        if not ((13, 3) < self.xcode_version < (14,)):
            return string
        lines = []
        for line in string.splitlines():
            if self._spam_warnings_re.search(line):
                continue
            lines.append(line)
        return '\n'.join(lines)

    @property
    def xcode_version(self):
        out = subprocess.check_output(['xcodebuild', '-version'],
                                      encoding='utf-8')
        version_string = out.split()[1]
        return tuple(map(int, version_string.split('.')))


if __name__ == '__main__':
    unittest.main()
