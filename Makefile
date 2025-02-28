.PHONY: test integration_test generate coverage build

build_grpc_parser:
	cd grpc_parser && go build .

test:
	rm -f coverage/lcov.info
	flutter test ./test -r github --coverage --concurrency=1

integration_test:
	flutter test ./integration_test/main.dart --coverage --coverage-path=coverage/integration_test_coverage.info

generate:
	protoc --dart_out=grpc:lib/agent/gen -Ilib/agent lib/agent/api.proto

coverage:
	rm -rf coverage/html
	lcov --ignore-errors unused --remove coverage/lcov.info $$(cat .coveragefilter) -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/html

build: build_grpc_parser
	flutter build linux

pkg-deb:
	rm -f dist/trayce.deb && rm -rf dist/trayce; \
	mkdir -p dist/trayce/DEBIAN; \
	mkdir -p dist/trayce/usr/local/lib/trayce; \
	mkdir -p dist/trayce/usr/share/applications; \
	cp -a build/linux/x64/release/bundle/. dist/trayce/usr/local/lib/trayce/; \
	cp include/DEBIAN/* dist/trayce/DEBIAN/; \
	cp include/icon_128x128.png dist/trayce/usr/local/lib/trayce/; \
	cp dist/trayce/DEBIAN/trayce.desktop dist/trayce/usr/share/applications/; \
	dpkg-deb --build dist/trayce
