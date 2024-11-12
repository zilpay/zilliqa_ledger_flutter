import 'dart:typed_data';
import 'package:ledger_flutter/ledger_flutter.dart';

/// APDU Protocol implementation for getting Zilliqa public address
class ZilliqaPublicAddressOperation
    extends LedgerOperation<({String publicKey, String address})> {
  static const cla = 0xE0;
  static const ins = 0x02;
  static const pubKeyByteLen = 33;
  static const bech32AddrLen = 39; // 'zil'.length + 1 + 32 + 6

  final int accountIndex;

  ZilliqaPublicAddressOperation(this.accountIndex);

  @override
  Future<List<Uint8List>> write(ByteDataWriter writer) async {
    writer.writeUint8(cla); // CLA
    writer.writeUint8(ins); // INS: getPublicAddress
    writer.writeUint8(0x00); // P1
    writer.writeUint8(0x01); // P2: request public address
    writer.writeUint8(0x04); // Data length (4 bytes for index)
    writer.writeInt32(accountIndex, Endian.little); // Account index

    return [writer.toBytes()];
  }

  @override
  Future<({String publicKey, String address})> read(
      ByteDataReader reader) async {
    // First pubKeyByteLen bytes are the public key
    final publicKeyBytes = reader.read(pubKeyByteLen);
    final publicKey = publicKeyBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();

    // Next bech32AddrLen bytes are the bech32 address string
    final addressBytes = reader.read(bech32AddrLen);
    final address = String.fromCharCodes(addressBytes);

    return (publicKey: publicKey, address: address);
  }
}
