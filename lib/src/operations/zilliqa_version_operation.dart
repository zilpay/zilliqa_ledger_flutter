import 'dart:typed_data';
import 'package:ledger_flutter/ledger_flutter.dart';
import '../zilliqa_version.dart';

/// Get Version APDU Protocol implementation for Zilliqa
class ZilliqaVersionOperation extends LedgerOperation<ZilliqaVersion> {
  static const cla = 0xE0;
  static const ins = 0x01;

  ZilliqaVersionOperation();

  @override
  Future<List<Uint8List>> write(ByteDataWriter writer) async {
    writer.writeUint8(cla); // CLA
    writer.writeUint8(ins); // INS: getVersion
    writer.writeUint8(0x00); // P1
    writer.writeUint8(0x00); // P2
    writer.writeUint8(0x00); // Data length

    return [writer.toBytes()];
  }

  @override
  Future<ZilliqaVersion> read(ByteDataReader reader) async {
    // Response contains 3 integers for major, minor, patch
    final major = reader.readUint8();
    final minor = reader.readUint8();
    final patch = reader.readUint8();

    return ZilliqaVersion(
      major: major,
      minor: minor,
      patch: patch,
    );
  }
}
