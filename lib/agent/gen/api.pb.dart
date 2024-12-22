//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Flow extends $pb.GeneratedMessage {
  factory Flow({
    $core.String? uuid,
    $core.String? localAddr,
    $core.String? remoteAddr,
    $core.String? l4Protocol,
    $core.String? l7Protocol,
    $core.List<$core.int>? request,
    $core.List<$core.int>? response,
  }) {
    final $result = create();
    if (uuid != null) {
      $result.uuid = uuid;
    }
    if (localAddr != null) {
      $result.localAddr = localAddr;
    }
    if (remoteAddr != null) {
      $result.remoteAddr = remoteAddr;
    }
    if (l4Protocol != null) {
      $result.l4Protocol = l4Protocol;
    }
    if (l7Protocol != null) {
      $result.l7Protocol = l7Protocol;
    }
    if (request != null) {
      $result.request = request;
    }
    if (response != null) {
      $result.response = response;
    }
    return $result;
  }
  Flow._() : super();
  factory Flow.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Flow.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Flow', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uuid')
    ..aOS(2, _omitFieldNames ? '' : 'localAddr')
    ..aOS(3, _omitFieldNames ? '' : 'remoteAddr')
    ..aOS(4, _omitFieldNames ? '' : 'l4Protocol')
    ..aOS(5, _omitFieldNames ? '' : 'l7Protocol')
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'request', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(7, _omitFieldNames ? '' : 'response', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Flow clone() => Flow()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Flow copyWith(void Function(Flow) updates) => super.copyWith((message) => updates(message as Flow)) as Flow;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Flow create() => Flow._();
  Flow createEmptyInstance() => create();
  static $pb.PbList<Flow> createRepeated() => $pb.PbList<Flow>();
  @$core.pragma('dart2js:noInline')
  static Flow getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Flow>(create);
  static Flow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get localAddr => $_getSZ(1);
  @$pb.TagNumber(2)
  set localAddr($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocalAddr() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalAddr() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get remoteAddr => $_getSZ(2);
  @$pb.TagNumber(3)
  set remoteAddr($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRemoteAddr() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemoteAddr() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get l4Protocol => $_getSZ(3);
  @$pb.TagNumber(4)
  set l4Protocol($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasL4Protocol() => $_has(3);
  @$pb.TagNumber(4)
  void clearL4Protocol() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get l7Protocol => $_getSZ(4);
  @$pb.TagNumber(5)
  set l7Protocol($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasL7Protocol() => $_has(4);
  @$pb.TagNumber(5)
  void clearL7Protocol() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get request => $_getN(5);
  @$pb.TagNumber(6)
  set request($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRequest() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequest() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get response => $_getN(6);
  @$pb.TagNumber(7)
  set response($core.List<$core.int> v) { $_setBytes(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasResponse() => $_has(6);
  @$pb.TagNumber(7)
  void clearResponse() => clearField(7);
}

class Flows extends $pb.GeneratedMessage {
  factory Flows({
    $core.Iterable<Flow>? flows,
  }) {
    final $result = create();
    if (flows != null) {
      $result.flows.addAll(flows);
    }
    return $result;
  }
  Flows._() : super();
  factory Flows.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Flows.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Flows', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..pc<Flow>(1, _omitFieldNames ? '' : 'flows', $pb.PbFieldType.PM, subBuilder: Flow.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Flows clone() => Flows()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Flows copyWith(void Function(Flows) updates) => super.copyWith((message) => updates(message as Flows)) as Flows;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Flows create() => Flows._();
  Flows createEmptyInstance() => create();
  static $pb.PbList<Flows> createRepeated() => $pb.PbList<Flows>();
  @$core.pragma('dart2js:noInline')
  static Flows getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Flows>(create);
  static Flows? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Flow> get flows => $_getList(0);
}

class Reply extends $pb.GeneratedMessage {
  factory Reply({
    $core.String? status,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  Reply._() : super();
  factory Reply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Reply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Reply', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Reply clone() => Reply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Reply copyWith(void Function(Reply) updates) => super.copyWith((message) => updates(message as Reply)) as Reply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reply create() => Reply._();
  Reply createEmptyInstance() => create();
  static $pb.PbList<Reply> createRepeated() => $pb.PbList<Reply>();
  @$core.pragma('dart2js:noInline')
  static Reply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reply>(create);
  static Reply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class AgentStarted extends $pb.GeneratedMessage {
  factory AgentStarted() => create();
  AgentStarted._() : super();
  factory AgentStarted.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AgentStarted.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AgentStarted', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AgentStarted clone() => AgentStarted()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AgentStarted copyWith(void Function(AgentStarted) updates) => super.copyWith((message) => updates(message as AgentStarted)) as AgentStarted;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AgentStarted create() => AgentStarted._();
  AgentStarted createEmptyInstance() => create();
  static $pb.PbList<AgentStarted> createRepeated() => $pb.PbList<AgentStarted>();
  @$core.pragma('dart2js:noInline')
  static AgentStarted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentStarted>(create);
  static AgentStarted? _defaultInstance;
}

class NooP extends $pb.GeneratedMessage {
  factory NooP() => create();
  NooP._() : super();
  factory NooP.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NooP.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NooP', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NooP clone() => NooP()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NooP copyWith(void Function(NooP) updates) => super.copyWith((message) => updates(message as NooP)) as NooP;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NooP create() => NooP._();
  NooP createEmptyInstance() => create();
  static $pb.PbList<NooP> createRepeated() => $pb.PbList<NooP>();
  @$core.pragma('dart2js:noInline')
  static NooP getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NooP>(create);
  static NooP? _defaultInstance;
}

class Command extends $pb.GeneratedMessage {
  factory Command({
    $core.String? type,
    Settings? settings,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  Command._() : super();
  factory Command.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Command.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Command', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOM<Settings>(2, _omitFieldNames ? '' : 'settings', subBuilder: Settings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Command clone() => Command()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Command copyWith(void Function(Command) updates) => super.copyWith((message) => updates(message as Command)) as Command;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  Settings get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings(Settings v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => clearField(2);
  @$pb.TagNumber(2)
  Settings ensureSettings() => $_ensure(1);
}

class Settings extends $pb.GeneratedMessage {
  factory Settings({
    $core.Iterable<$core.String>? containerIds,
  }) {
    final $result = create();
    if (containerIds != null) {
      $result.containerIds.addAll(containerIds);
    }
    return $result;
  }
  Settings._() : super();
  factory Settings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Settings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Settings', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'containerIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Settings clone() => Settings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Settings copyWith(void Function(Settings) updates) => super.copyWith((message) => updates(message as Settings)) as Settings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  Settings createEmptyInstance() => create();
  static $pb.PbList<Settings> createRepeated() => $pb.PbList<Settings>();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get containerIds => $_getList(0);
}

class Request extends $pb.GeneratedMessage {
  factory Request({
    $core.int? num,
  }) {
    final $result = create();
    if (num != null) {
      $result.num = num;
    }
    return $result;
  }
  Request._() : super();
  factory Request.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Request.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Request', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'num', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Request clone() => Request()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Request copyWith(void Function(Request) updates) => super.copyWith((message) => updates(message as Request)) as Request;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Request create() => Request._();
  Request createEmptyInstance() => create();
  static $pb.PbList<Request> createRepeated() => $pb.PbList<Request>();
  @$core.pragma('dart2js:noInline')
  static Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Request>(create);
  static Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get num => $_getIZ(0);
  @$pb.TagNumber(1)
  set num($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNum() => $_has(0);
  @$pb.TagNumber(1)
  void clearNum() => clearField(1);
}

class Response extends $pb.GeneratedMessage {
  factory Response({
    $core.int? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  Response._() : super();
  factory Response.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Response.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Response', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'result', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Response clone() => Response()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Response copyWith(void Function(Response) updates) => super.copyWith((message) => updates(message as Response)) as Response;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Response create() => Response._();
  Response createEmptyInstance() => create();
  static $pb.PbList<Response> createRepeated() => $pb.PbList<Response>();
  @$core.pragma('dart2js:noInline')
  static Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response>(create);
  static Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get result => $_getIZ(0);
  @$pb.TagNumber(1)
  set result($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
}

class Container extends $pb.GeneratedMessage {
  factory Container({
    $core.String? id,
    $core.String? image,
    $core.String? ip,
    $core.String? name,
    $core.String? status,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (image != null) {
      $result.image = image;
    }
    if (ip != null) {
      $result.ip = ip;
    }
    if (name != null) {
      $result.name = name;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  Container._() : super();
  factory Container.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Container.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Container', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'image')
    ..aOS(3, _omitFieldNames ? '' : 'ip')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Container clone() => Container()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Container copyWith(void Function(Container) updates) => super.copyWith((message) => updates(message as Container)) as Container;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Container create() => Container._();
  Container createEmptyInstance() => create();
  static $pb.PbList<Container> createRepeated() => $pb.PbList<Container>();
  @$core.pragma('dart2js:noInline')
  static Container getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Container>(create);
  static Container? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get image => $_getSZ(1);
  @$pb.TagNumber(2)
  set image($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearImage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get ip => $_getSZ(2);
  @$pb.TagNumber(3)
  set ip($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIp() => $_has(2);
  @$pb.TagNumber(3)
  void clearIp() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);
}

class Containers extends $pb.GeneratedMessage {
  factory Containers({
    $core.Iterable<Container>? containers,
  }) {
    final $result = create();
    if (containers != null) {
      $result.containers.addAll(containers);
    }
    return $result;
  }
  Containers._() : super();
  factory Containers.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Containers.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Containers', package: const $pb.PackageName(_omitMessageNames ? '' : 'api'), createEmptyInstance: create)
    ..pc<Container>(1, _omitFieldNames ? '' : 'containers', $pb.PbFieldType.PM, subBuilder: Container.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Containers clone() => Containers()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Containers copyWith(void Function(Containers) updates) => super.copyWith((message) => updates(message as Containers)) as Containers;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Containers create() => Containers._();
  Containers createEmptyInstance() => create();
  static $pb.PbList<Containers> createRepeated() => $pb.PbList<Containers>();
  @$core.pragma('dart2js:noInline')
  static Containers getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Containers>(create);
  static Containers? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Container> get containers => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
