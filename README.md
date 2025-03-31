# TrayceGUI

TrayceGUI is a cross-platform desktop application which lets you interface with the TrayceAgent to monitor network requests in Docker containers.

## Build

Run `make build-linux` or `make build-mac`

## Develop

Install Flutter SDK: [Linux](https://docs.flutter.dev/get-started/install/linux/desktop) or [Mac](https://docs.flutter.dev/get-started/install/macos/desktop#install-the-flutter-sdk).

Run the app:
`flutter run`

Generate protobuf files:
```
dart pub global activate protoc_plugin
make generate
```

## Test

Run widget tests:
`make test`

Run integration tests:
`make integration_test`

## Troubleshooting

Linux Mint - not able to type in text fields, solved by Disabling on-screen keyboard in accesibility settings: https://github.com/flutter/flutter/issues/153560#issuecomment-2503660633
