// swift-tools-version:5.0
import Foundation
import PackageDescription

let developerDir: String = {
    if let environmentVariable = ProcessInfo.processInfo.environment["DEVELOPER_DIR"] {
        return environmentVariable
    }
    if #available(macOS 10.0, *) {
        let pipe = Pipe()
        let process = Process()
        process.launchPath = "/usr/bin/xcode-select"
        process.arguments = ["-p"]
        process.standardOutput = pipe
        process.launch()
        process.waitUntilExit()
        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    // $DEVELOPER_DIR was not found. Assuming as "/Applications/Xcode.app/Contents/Developer"
    return "/Applications/Xcode.app/Contents/Developer"
}()

let package = Package(
    name: "xcnew",
    targets: [
        .target(
            name: "xcnew",
            linkerSettings: [
                .linkedFramework("DVTFoundation"),
                .linkedFramework("IDEFoundation"),
                .unsafeFlags([
                    "-F\(developerDir)/../Frameworks",
                    "-F\(developerDir)/../SharedFrameworks",
                    "-Xlinker",
                    "-rpath",
                    "-Xlinker",
                    "\(developerDir)/../Frameworks",
                    "-Xlinker",
                    "-rpath",
                    "-Xlinker",
                    "\(developerDir)/../SharedFrameworks",
                ])
            ]),
        .testTarget(
            name: "xcnew-tests",
            cSettings: [
                .unsafeFlags(["-ISources/xcnew"])
            ])
    ]
)
