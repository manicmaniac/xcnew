xcnew
=====

[![GitHub Actions](https://github.com/manicmaniac/xcnew/actions/workflows/test.yml/badge.svg)](https://github.com/manicmaniac/xcnew/actions/workflows/test.yml)
[![Xcode](https://img.shields.io/badge/xcode-12%20%7C%2013-blue)](https://github.com/manicmaniac/xcnew#supported-xcode-versions)

A command line interface to make a project for iOS Single View App.

Install
-------

You can install `xcnew` via [Homebrew](https://brew.sh).

    brew install manicmaniac/tap/xcnew

Otherwise good old `make install` creates `/usr/local/bin/xcnew` command.
You may need to use `sudo` to run `make install`.

    make install

If you prefer, you can change the base path to install with `PREFIX` environment variable.

    PREFIX=~/bin make install

Usage
-----

<!-- xml2c:start -->
    xcnew - A command line tool to create Xcode project.
    
    Usage: xcnew [-h|-v] [-n ORG_NAME] [-i ORG_ID] [-tucos] <PRODUCT_NAME> [OUTPUT_DIR]
    
    Options:
        -h, --help                     Show help and exit
        -v, --version                  Show version and exit
        -i, --organization-identifier  Specify organization's identifier
        -t, --has-tests                Enable unit and UI tests
        -c, --use-core-data            Enable Core Data template
        -C, --use-cloud-kit            Enable Core Data with CloudKit template (overrides -c option)
        -o, --objc                     Use Objective-C instead of Swift (overridden by -s and -S options)
        -s, --swift-ui                 Use Swift UI instead of Storyboard
        -S, --swift-ui-lifecycle       Use Swift UI lifecycle (overrides -s option)
    
    Arguments:
        <PRODUCT_NAME>                 Required TARGET_NAME of project.pbxproj
        [OUTPUT_DIR]                   Optional directory name of the project
<!-- xml2c:end -->

Supported Xcode versions
------------------------

`Xcode >= 12.5 && Xcode <= 13.4.1`.

How it works?
-------------

Just by reverse engineering and utilizing Xcode private frameworks, `IDEFoundation` and `Xcode3Core`.

Why not Swift but Objective-C?
------------------------------

Simply too difficult to implement this kind of magic in Swift.

License
-------

This program is distributed under the MIT license.
See LICENSE for the detail.
