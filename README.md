xcnew
=====

[![GitHub Actions](https://github.com/manicmaniac/xcnew/actions/workflows/test.yml/badge.svg)](https://github.com/manicmaniac/xcnew/actions/workflows/test.yml)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1b708551a78044461357/test_coverage)](https://codeclimate.com/github/manicmaniac/xcnew/test_coverage)
[![Xcode](https://img.shields.io/badge/xcode-12%20%7C%2013-blue)](https://github.com/manicmaniac/xcnew#supported-xcode-versions)

A command line interface to make a project for iOS Single View App.

Install
-------

### Homebrew

    brew install manicmaniac/tap/xcnew

### MacPorts

Firstly you need to setup local repository.

    git clone https://github.com/manicmaniac/ports.git

Then add the repository to MacPorts sources.

    sudo ruby -pi -e 'puts "file://#{Dir.pwd}/ports" if /^rsync:/' /opt/local/etc/macports/sources.conf

Now you can install xcnew from ports.

    sudo port install xcnew

### Install from binary package

Make sure you set a developer directory to Xcode.

    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

Then download the latest package.

    curl -LO https://github.com/manicmaniac/releases/latest/download/xcnew.pkg

And install it to `/usr/local/bin/xcnew`.

    sudo installer -pkg xcnew.pkg -target /

### Install from source

    git clone https://github.com/manicmaniac/xcnew.git
    sudo make -C xcnew install

You can change the install location by setting `$PREFIX` environment variable.

    sudo make -C xcnew install PREFIX="/opt/local"

Usage
-----

<!-- xml2c:start -->
    xcnew - A command line interface to make a project for iOS Single View App.

    Usage: xcnew [-h|v] [-i <ORG_ID>] [-tcCosS] <PRODUCT_NAME> [OUTPUT_DIR]

    Options:
        -h, --help                Show help and exit
        -v, --version             Show version and exit
        -i <ORG_ID>, --organization-identifier <ORG_ID>
                                  Specify organization's identifier
        -t, --has-tests           Enable unit and UI tests
        -c, --use-core-data       Enable Core Data template
        -C, --use-cloud-kit       Enable Core Data with CloudKit template (overrides -c option)
        -o, --objc                Use Objective-C instead of Swift (overridden by -s and -S options)
        -s, --swift-ui            Use Swift UI instead of Storyboard
        -S, --swift-ui-lifecycle  Use Swift UI lifecycle (overrides -s option)

    Arguments:
        <PRODUCT_NAME>            Required TARGET_NAME of project.pbxproj
        [OUTPUT_DIR]              Optional directory name of the project
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
