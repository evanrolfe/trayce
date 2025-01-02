# TrayceGUI

TrayceGUI is a cross-platform desktop application which lets you interface with the TrayceAgent to monitor network requests in Docker containers.


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
`flutter test ./test`

Run integration tests:
`flutter test ./integration_test`

Update screenshots:
`flutter test ./integration_test/ --update-goldens`
