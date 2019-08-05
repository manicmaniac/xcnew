xcnew
=====

A command line interface to make a project for iOS Single View App.

Install
-------

Good old `make install` creates `/usr/local/bin/xcnew` command.
You may need to use `sudo` to run `make install`.

    make
    make install

If you prefer, you can change the base path to install with `PREFIX` environment variable.

    make
    PREFIX=/bin make install

Usage
-----

    xcnew - A command line tool to create Xcode project.
    
    Usage: xcnew [-h] [-n ORG_NAME] [-i ORG_ID] [-tuco] <PRODUCT_NAME> <OUTPUT_DIR>
    
    Options:
        -h, --help                     Show this help and exit
        -v, --version                  Show version and exit
        -n, --organization-name        Specify organization's name
        -i, --organization-identifier  Specify organization's identifier
        -t, --has-unit-tests           Enable unit tests
        -u, --has-ui-tests             Enable UI tests
        -c, --use-core-data            Enable Core Data template
        -o, --objc                     Use Objective-C (default: Swift)

How it works
------------

Just by using Xcode private frameworks, `IDEFoundation` and `Xcode3Core`.

License
-------

This program is distributed under the MIT license.
See LICENSE for the detail.
