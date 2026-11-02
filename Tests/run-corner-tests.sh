#!/bin/zsh
set -euo pipefail

corner_simulator_id="${1:?Usage: zsh Tests/run-corner-tests.sh BOOTED_SIMULATOR_ID [DERIVED_DATA]}"
corner_derived_data="${2:-/private/tmp/PT-LNPopupCorner-Tests}"
corner_developer_dir="${DEVELOPER_DIR:-/Volumes/SSD1/Applications/Xcode-26.2.app/Contents/Developer}"
corner_repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$corner_repo_dir"

"$corner_developer_dir/usr/bin/xcodebuild" -quiet \
    -scheme LNPopupController-Package \
    -destination "platform=iOS Simulator,id=$corner_simulator_id" \
    -derivedDataPath "$corner_derived_data" \
    CODE_SIGNING_ALLOWED=NO build-for-testing

DEVELOPER_DIR="$corner_developer_dir" \
SIMCTL_CHILD_DYLD_FRAMEWORK_PATH="$corner_developer_dir/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks" \
SIMCTL_CHILD_DYLD_LIBRARY_PATH="$corner_derived_data/Build/Products/Debug-iphonesimulator" \
xcrun simctl spawn "$corner_simulator_id" \
    "$corner_developer_dir/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/Agents/xctest" \
    "$corner_derived_data/Build/Products/Debug-iphonesimulator/LNPopupCornerTests.xctest"
