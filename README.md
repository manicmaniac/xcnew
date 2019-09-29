xcnew
=====

[![Actions Status](https://github.com/manicmaniac/xcnew/workflows/CI/badge.svg)](https://github.com/manicmaniac/xcnew/actions)

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

    xcnew - A command line tool to create Xcode project.
    
    Usage: xcnew [-h|-v] [-n ORG_NAME] [-i ORG_ID] [-tuco] <PRODUCT_NAME> [OUTPUT_DIR]
    
    Options:
        -h, --help                     Show this help and exit
        -v, --version                  Show version and exit
        -n, --organization-name        Specify organization's name
        -i, --organization-identifier  Specify organization's identifier
        -t, --has-unit-tests           Enable unit tests
        -u, --has-ui-tests             Enable UI tests
        -c, --use-core-data            Enable Core Data template
        -o, --objc                     Use Objective-C (default: Swift)
    
    Arguments:
        <PRODUCT_NAME>                 Required TARGET_NAME of project.pbxproj
        [OUTPUT_DIR]                   Optional directory name of the project

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
