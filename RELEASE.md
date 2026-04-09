# Church Smartly Release Guide

## Android (Google Play)

1. Keystore file:
   - Path: `android/app/churchsmartly-upload.jks`
2. Keystore config:
   - Path: `android/key.properties` (ignored by git)
   - Template: `android/key.properties.example`
3. Ensure release signing is enabled in `android/app/build.gradle.kts`.
4. Build release artifacts:

```bash
flutter build appbundle --release
flutter build apk --release
```

Output locations:
- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/flutter-apk/app-release.apk`

## iOS (App Store Connect)

1. Bundle identifier:
   - `com.arobiloutsourcing.churchsmartlyapp`
2. In Xcode (`ios/Runner.xcworkspace`), verify:
   - Team selected
   - Signing certificate/provisioning profile valid
   - Version/build number updated
3. Build without signing (CI/local verification):

```bash
flutter build ipa --release --no-codesign
```

4. For App Store upload, archive in Xcode and distribute to App Store Connect.

## Versioning

Update version in `pubspec.yaml` before each submission:
- `version: MAJOR.MINOR.PATCH+BUILD`

Example:
- `version: 1.0.1+2`

## Important

- Back up `android/app/churchsmartly-upload.jks` and your keystore passwords securely.
- Do not commit `android/key.properties` or the keystore to source control.