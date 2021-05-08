Stubs of Xcode private frameworks
==================================

**This document is for developers.**

Files under this folder are stubs of Xcode private frameworks.

How to create headers
---------------------

Their headers are generated with a script `Scripts/dump-private-headers`.

The script records last-used tool versions in `Library/Frameworks/.versions`.

How to create text-based API files
----------------------------------

Their stub API files (`.tbd`) can be generated with the following script.

```sh
xcrun tapi installapi \
    -target x86_64-apple-macosx \
    -install_name '@rpath/DVTFoundation.framework/Versions/A/DVTFoundation' \
    -F Library/Frameworks \
    -extra-public-header Library/Frameworks/DVTFoundation.framework/Headers \
    -o Library/Frameworks/DVTFoundation.framework/DVTFoundation.tbd \
    "$DEVELOPER_DIR/../SharedFrameworks/DVTFoundation.framework"

xcrun tapi installapi \
    -target x86_64-apple-macosx \
    -install_name '@rpath/IDEFoundation.framework/Versions/A/IDEFoundation' \
    -F Library/Frameworks \
    -extra-public-header Library/Frameworks/IDEFoundation.framework/Headers \
    -o Library/Frameworks/IDEFoundation.framework/IDEFoundation.tbd \
    "$DEVELOPER_DIR/../Frameworks/IDEFoundation.framework"
```

It must work on your computer but because of compatibility issue in `.tbd` file format, it doesn't work on other environments where an older version of Xcode is installed.
As far as I know, Xcode 10 interprets only legacy version of `.tbd` while Xcode 12's `tapi` exports version 4.

To overcome this situation, you may need to modify `.tbd` files to downgrade version like the following way.

1. Remove `!tapi-tbd` at the first line.
2. Remove `tbd-version` entry.
3. Replace `target` to `arch`.
4. Add `platform: macosx` entry.
5. Add `_` prefix to all `objc-classes` values.
6. Remove all `objc-ivars` entries.
