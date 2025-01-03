.PHONY: test integration_test generate coverage

test:
	rm -f coverage/lcov.info
	flutter test ./test -r github --coverage

integration_test:
	flutter test ./integration_test/main.dart --coverage --coverage-path=coverage/integration_test_coverage.info

generate:
	protoc --dart_out=grpc:lib/agent/gen -Ilib/agent lib/agent/api.proto

coverage:
	rm -rf coverage/html
	lcov --ignore-errors unused --remove coverage/lcov.info $$(cat .coveragefilter) -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/html
