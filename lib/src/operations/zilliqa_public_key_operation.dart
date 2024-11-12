import 'dart:typed_data';
import 'package:ledger_flutter/ledger_flutter.dart';

/// APDU Protocol implementation for getting Zilliqa public key
class ZilliqaPublicKeyOperation extends LedgerOperation<String> {
  static const cla = 0xE0;
  static const ins = 0x02;
  static const pubKeyByteLen = 33;

  final int accountIndex;

  ZilliqaPublicKeyOperation(this.accountIndex);

  @override
  Future<List<Uint8List>> write(ByteDataWriter writer) async {
    writer.writeUint8(cla); // CLA
    writer.writeUint8(ins); // INS: getPublicKey
    writer.writeUint8(0x00); // P1
    writer.writeUint8(0x00); // P2
    writer.writeUint8(0x04); // Data length (4 bytes for index)
    writer.writeInt32(accountIndex, Endian.little); // Account index

    return [writer.toBytes()];
  }

  @override
  Future<String> read(ByteDataReader reader) async {
    // Read pubKeyByteLen bytes for the public key
    final publicKeyBytes = reader.read(pubKeyByteLen);
    return publicKeyBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
