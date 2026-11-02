# Corner compatibility regression

The fixture exercises the real `LNPopupBar.layoutSubviews` path in compact style with bottom progress. Private state is injected only in the test target; no production hooks or UIKit swizzling are added. Swift private support is linked because the library requires it during initialization.

Test doubles independently advertise the presence or absence of the radius method and configuration setter, and record invocations. This catches an unsupported message without deliberately terminating XCTest. It is not a reproduction on the original iOS 26.0 device.

Four cases cover supported geometry, missing radius, missing setter with supported radius, and both absent. Missing factories and Catalyst capsule behavior are source-reviewed, not runtime-simulated. Pre-iOS 26 compatibility needs its own runtime check; these cases target the iOS 26+ availability boundary.

On a booted iOS 26+ simulator, run:

```sh
zsh Tests/run-corner-tests.sh SIMULATOR_UDID
```

The script builds with Xcode 26.2 by default and runs the compiled XCTest bundle directly. `DEVELOPER_DIR` can select another installed toolchain. Tests are synchronous because the layout is synchronous; this also avoids the async XCTest runner failure observed on this host. The script does not boot/shutdown devices, sign an application, or publish anything.

Baseline `a130f0b` with this harness: one case passed, three failed with seven assertions. Patched source on iOS 26.3.1: four passed, zero failures.
