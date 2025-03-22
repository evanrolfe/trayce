# TrayceGUI

TrayceGUI is a cross-platform desktop application which lets you interface with the TrayceAgent to monitor network requests in Docker containers.

## Build

Run `make build-linux` or `make build-mac`

## Develop

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
