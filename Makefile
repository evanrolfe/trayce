integration_test:
	rm -rf .dart_tool/sqflite_common_ffi/databases/tmp.db
	flutter test ./integration_test

generate:
	protoc --dart_out=grpc:lib/agent/gen -Ilib/agent lib/agent/api.proto

