# Generate icon
```
flutter pub run flutter_launcher_icons
```

# Deployment

## Update version
Update the version in pubspec.yaml.

For example, the `+6` is the build version, while `1.0.1` is the app version.
You should increment the build version for each new update or will be deemed as same build.
`version: 1.0.1+6`

## Android
`flutter build appbundle`
