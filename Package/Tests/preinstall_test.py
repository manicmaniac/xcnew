#!/usr/bin/env python3

import shutil
import subprocess
import tempfile
import shlex
import os
import unittest


class PreinstallTest(unittest.TestCase):
    executable_path = os.path.normpath(os.path.join(__file__, '../../Scripts/preinstall'))
    fixtures_path = os.path.normpath(os.path.join(__file__, '../Fixtures'))

    def setUp(self):
        self.original_developer_dir = subprocess.check_output(['xcode-select', '--print-path'], encoding='utf-8').rstrip()
        self.tmpdir = tempfile.TemporaryDirectory()
        self.setup_installer_payload_dir()
        self.setup_developer_dir()

    def tearDown(self):
        self.tmpdir.cleanup()

    def test_preinstall(self):
        out, err, status = self.run_preinstall(self.xcode_developer_dir)
        self.assertEqual(out, '')
        self.assertEqual(err, '')
        self.assertEqual(status, 0)
        self.assertTrue(all(rpath.startswith(self.xcode_developer_dir) for rpath in self.get_rpaths()))

    def test_preinstall_when_developer_dir_is_not_in_xcode(self):
        out, err, status = self.run_preinstall(self.command_line_tools_developer_dir)
        self.assertEqual(out, '')
        self.assertEqual(err, '')
        self.assertEqual(status, 1)
        self.assertTrue(all(rpath.startswith('/Applications') for rpath in self.get_rpaths()))

    def run_preinstall(self, developer_dir):
        args = []
        env = {
            'DEVELOPER_DIR': developer_dir,
            'INSTALLER_PAYLOAD_DIR': self.installer_payload_dir,
        }
        process = subprocess.Popen(args,
                                   executable=self.executable_path,
                                   cwd=self.tmpdir.name,
                                   env=env,
                                   encoding='utf-8',
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        out, err = process.communicate(timeout=5)
        return (out, err, process.returncode)

    def get_rpaths(self):
        rpaths = []
        in_rpath = False
        out = subprocess.check_output(['otool', '-l', self.xcnew_path], encoding='utf-8')
        for line in out.splitlines():
            line = line.strip()
            if line.startswith('cmd LC_RPATH'):
                in_rpath = True
            elif in_rpath and line.startswith('path /'):
                rpath = line.split(' ')[1]
                rpaths.append(rpath)
                in_rpath = False
        return rpaths

    def setup_installer_payload_dir(self):
        self.installer_payload_dir = os.path.join(self.tmpdir.name, 'Payload')
        bin_dir = os.path.join(self.installer_payload_dir, 'usr', 'local', 'bin')
        os.makedirs(bin_dir)
        self.xcnew_path = os.path.join(bin_dir, 'xcnew')
        shutil.copy(os.path.join(self.fixtures_path, 'xcnew'), self.xcnew_path)

    def setup_developer_dir(self):
        self.setup_command_line_tools_developer_dir()
        self.setup_xcode_developer_dir()

    def setup_command_line_tools_developer_dir(self):
        self.command_line_tools_developer_dir = os.path.join(self.tmpdir.name, 'Library', 'Developer', 'CommandLineTools')
        os.makedirs(self.command_line_tools_developer_dir)

    def setup_xcode_developer_dir(self):
        contents_dir = os.path.join(self.tmpdir.name, 'Applications', 'Xcode.app', 'Contents')
        self.xcode_developer_dir = os.path.join(contents_dir, 'Developer')
        bin_dir = os.path.join(self.xcode_developer_dir, 'usr', 'bin')
        os.makedirs(bin_dir)
        with open(os.path.join(contents_dir, 'Info.plist'), 'w') as f:
            f.write('CFBundleIdentifier = "com.apple.dt.Xcode";\n')
        xcrun_path = os.path.join(bin_dir, 'xcrun')
        with open(xcrun_path, 'w') as f:
            f.write('#!/bin/sh\n')
            f.write('DEVELOPER_DIR={} "$@"'.format(shlex.quote(self.original_developer_dir)))
        os.chmod(xcrun_path, 0o700)


if __name__ == '__main__':
    unittest.main()
