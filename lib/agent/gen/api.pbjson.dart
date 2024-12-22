//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use flowDescriptor instead')
const Flow$json = {
  '1': 'Flow',
  '2': [
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'local_addr', '3': 2, '4': 1, '5': 9, '10': 'localAddr'},
    {'1': 'remote_addr', '3': 3, '4': 1, '5': 9, '10': 'remoteAddr'},
    {'1': 'l4_protocol', '3': 4, '4': 1, '5': 9, '10': 'l4Protocol'},
    {'1': 'l7_protocol', '3': 5, '4': 1, '5': 9, '10': 'l7Protocol'},
    {'1': 'request', '3': 6, '4': 1, '5': 12, '10': 'request'},
    {'1': 'response', '3': 7, '4': 1, '5': 12, '10': 'response'},
  ],
};

/// Descriptor for `Flow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flowDescriptor = $convert.base64Decode(
    'CgRGbG93EhIKBHV1aWQYASABKAlSBHV1aWQSHQoKbG9jYWxfYWRkchgCIAEoCVIJbG9jYWxBZG'
    'RyEh8KC3JlbW90ZV9hZGRyGAMgASgJUgpyZW1vdGVBZGRyEh8KC2w0X3Byb3RvY29sGAQgASgJ'
    'UgpsNFByb3RvY29sEh8KC2w3X3Byb3RvY29sGAUgASgJUgpsN1Byb3RvY29sEhgKB3JlcXVlc3'
    'QYBiABKAxSB3JlcXVlc3QSGgoIcmVzcG9uc2UYByABKAxSCHJlc3BvbnNl');

@$core.Deprecated('Use flowsDescriptor instead')
const Flows$json = {
  '1': 'Flows',
  '2': [
    {'1': 'flows', '3': 1, '4': 3, '5': 11, '6': '.api.Flow', '10': 'flows'},
  ],
};

/// Descriptor for `Flows`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flowsDescriptor = $convert.base64Decode(
    'CgVGbG93cxIfCgVmbG93cxgBIAMoCzIJLmFwaS5GbG93UgVmbG93cw==');

@$core.Deprecated('Use replyDescriptor instead')
const Reply$json = {
  '1': 'Reply',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `Reply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyDescriptor = $convert.base64Decode(
    'CgVSZXBseRIWCgZzdGF0dXMYASABKAlSBnN0YXR1cw==');

@$core.Deprecated('Use agentStartedDescriptor instead')
const AgentStarted$json = {
  '1': 'AgentStarted',
};

/// Descriptor for `AgentStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentStartedDescriptor = $convert.base64Decode(
    'CgxBZ2VudFN0YXJ0ZWQ=');

@$core.Deprecated('Use nooPDescriptor instead')
const NooP$json = {
  '1': 'NooP',
};

/// Descriptor for `NooP`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nooPDescriptor = $convert.base64Decode(
    'CgROb29Q');

@$core.Deprecated('Use commandDescriptor instead')
const Command$json = {
  '1': 'Command',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'settings', '3': 2, '4': 1, '5': 11, '6': '.api.Settings', '10': 'settings'},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode(
    'CgdDb21tYW5kEhIKBHR5cGUYASABKAlSBHR5cGUSKQoIc2V0dGluZ3MYAiABKAsyDS5hcGkuU2'
    'V0dGluZ3NSCHNldHRpbmdz');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {'1': 'container_ids', '3': 1, '4': 3, '5': 9, '10': 'containerIds'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxIjCg1jb250YWluZXJfaWRzGAEgAygJUgxjb250YWluZXJJZHM=');

@$core.Deprecated('Use requestDescriptor instead')
const Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'num', '3': 1, '4': 1, '5': 5, '10': 'num'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode(
    'CgdSZXF1ZXN0EhAKA251bRgBIAEoBVIDbnVt');

@$core.Deprecated('Use responseDescriptor instead')
const Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 5, '10': 'result'},
  ],
};

/// Descriptor for `Response`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseDescriptor = $convert.base64Decode(
    'CghSZXNwb25zZRIWCgZyZXN1bHQYASABKAVSBnJlc3VsdA==');

@$core.Deprecated('Use containerDescriptor instead')
const Container$json = {
  '1': 'Container',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'image', '3': 2, '4': 1, '5': 9, '10': 'image'},
    {'1': 'ip', '3': 3, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `Container`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List containerDescriptor = $convert.base64Decode(
    'CglDb250YWluZXISDgoCaWQYASABKAlSAmlkEhQKBWltYWdlGAIgASgJUgVpbWFnZRIOCgJpcB'
    'gDIAEoCVICaXASEgoEbmFtZRgEIAEoCVIEbmFtZRIWCgZzdGF0dXMYBSABKAlSBnN0YXR1cw==');

@$core.Deprecated('Use containersDescriptor instead')
const Containers$json = {
  '1': 'Containers',
  '2': [
    {'1': 'containers', '3': 1, '4': 3, '5': 11, '6': '.api.Container', '10': 'containers'},
  ],
};

/// Descriptor for `Containers`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List containersDescriptor = $convert.base64Decode(
    'CgpDb250YWluZXJzEi4KCmNvbnRhaW5lcnMYASADKAsyDi5hcGkuQ29udGFpbmVyUgpjb250YW'
    'luZXJz');

