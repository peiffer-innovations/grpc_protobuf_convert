import 'package:fixnum/fixnum.dart';
import 'package:grpc_googleapis/google/protobuf.dart' as pb;

/// Utility class that helps convert from common Dart classes to Protobuf
/// standard classes.
class GrpcProtobufConvert {
  /// Converts a Protobuf Duration [value] to a Dart core Duration.
  static Duration fromDuration(pb.Duration value) => Duration(
        milliseconds: (value.seconds.toInt() * 1000) + (value.nanos ~/ 1000),
      );

  /// Converts a Protobuf Timestamp [value] to a Dart core DateTime.
  static DateTime fromTimestamp(
    pb.Timestamp value, {
    bool isUtc = true,
  }) =>
      DateTime.fromMillisecondsSinceEpoch(
        (value.seconds.toInt() * 1000) + (value.nanos ~/ 1000),
        isUtc: isUtc,
      );

  /// Converts a Dart core Duration [value] to a Protobuf Duration object.
  static pb.Duration toDuration(Duration value) {
    var seconds = value.inSeconds;
    var nanos =
        (value.inMilliseconds - Duration(seconds: seconds).inMilliseconds) *
            1000;
    return pb.Duration(
      nanos: nanos,
      seconds: toInt64(seconds),
    );
  }

  /// Converts a Dart native int [value] to an [Int64].  Note: this will not
  /// work properly on Web if there are more than 53 significant bits as native
  /// int values on Web only contain 53 significant bits vs the native 64 bits.
  static Int64 toInt64(int value) => Int64.parseInt(value.toString());

  /// Converts a Dart core DateTime [value] to a Protobuf Timestamp object.
  static pb.Timestamp toTimestamp(DateTime value) {
    var seconds = value.millisecondsSinceEpoch ~/ 1000;
    var nanos = (value.millisecondsSinceEpoch - (seconds * 1000)) * 1000;
    return pb.Timestamp(
      nanos: nanos,
      seconds: toInt64(seconds),
    );
  }
}
