import 'dart:typed_data';
import 'package:ledger_flutter/ledger_flutter.dart';

/// APDU Protocol implementation for signing message hashes
class ZilliqaSignHashOperation extends LedgerOperation<String> {
  static const cla = 0xE0;
  static const ins = 0x08;
  static const hashByteLen = 32;
  static const sigByteLen = 64;

  final int accountIndex;
  final Uint8List hash;

  ZilliqaSignHashOperation(this.accountIndex, this.hash) {
    if (hash.length > hashByteLen) {
      throw ArgumentError(
          'Hash length exceeds maximum allowed length of $hashByteLen bytes');
    }
  }

  @override
  Future<List<Uint8List>> write(ByteDataWriter writer) async {
    writer.writeUint8(cla); // CLA
    writer.writeUint8(ins); // INS: signHash
    writer.writeUint8(0x00); // P1
    writer.writeUint8(0x00); // P2

    // Calculate data length: 4(index) + hash length
    writer.writeUint8(4 + hash.length);

    // Write account index
    writer.writeInt32(accountIndex, Endian.little);

    // Write hash
    writer.write(hash);

    return [writer.toBytes()];
  }

  @override
  Future<String> read(ByteDataReader reader) async {
    // Read signature bytes and convert to hex string
    final signatureBytes = reader.read(sigByteLen);
    return signatureBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
