/*
 * This file is generated from Sources/xcnew/xcnew.mxml with xml2c.
 * DO NOT edit this file directly.
 */

#include <getopt.h>

const char XCNHelp[] = "xcnew - A command line interface to make a project for iOS Single View App.\n"
                       "\n"
                       "Usage: xcnew [-h|v] -i <ORG_ID> [-tcCosS] <PRODUCT_NAME> [OUTPUT_DIR]\n"
                       "\n"
                       "Options:\n"
                       "    -h, --help                Show help and exit\n"
                       "    -v, --version             Show version and exit\n"
                       "    -i <ORG_ID>, --organization-identifier <ORG_ID>\n"
                       "                              Specify organization's identifier\n"
                       "    -t, --has-tests           Enable unit and UI tests\n"
                       "    -c, --use-core-data       Enable Core Data template\n"
                       "    -C, --use-cloud-kit       Enable Core Data with CloudKit template (overrides -c option)\n"
                       "    -o, --objc                Use Objective-C instead of Swift (overridden by -s and -S options)\n"
                       "    -s, --swift-ui            Use Swift UI instead of Storyboard\n"
                       "    -S, --swift-ui-lifecycle  Use Swift UI lifecycle (overrides -s option)\n"
                       "\n"
                       "Arguments:\n"
                       "    <PRODUCT_NAME>            Required TARGET_NAME of project.pbxproj\n"
                       "    [OUTPUT_DIR]              Optional directory name of the project";

const char XCNShortOptions[] = "hvi:tcCosS";

const struct option XCNLongOptions[] = {
    {"help", no_argument, NULL, 'h'},
    {"version", no_argument, NULL, 'v'},
    {"organization-identifier", required_argument, NULL, 'i'},
    {"has-tests", no_argument, NULL, 't'},
    {"use-core-data", no_argument, NULL, 'c'},
    {"use-cloud-kit", no_argument, NULL, 'C'},
    {"objc", no_argument, NULL, 'o'},
    {"swift-ui", no_argument, NULL, 's'},
    {"swift-ui-lifecycle", no_argument, NULL, 'S'},
    {NULL, 0, NULL, 0},
};
