import 'dart:typed_data';
import 'package:ledger_flutter/ledger_flutter.dart';

/// APDU Protocol implementation for signing Zilliqa transactions
class ZilliqaSignTransactionOperation extends LedgerOperation<String> {
  static const cla = 0xE0;
  static const ins = 0x04;
  static const streamLen = 128; // Stream in batches of STREAM_LEN bytes
  static const sigByteLen = 64;

  final int accountIndex;
  final Uint8List encodedTx;

  /// Creates a new transaction signing operation
  /// [accountIndex] - The index of the account to sign with
  /// [encodedTx] - The transaction already encoded in protobuf format
  ZilliqaSignTransactionOperation(this.accountIndex, this.encodedTx);

  @override
  Future<List<Uint8List>> write(ByteDataWriter writer) async {
    var remainingBytes = encodedTx;
    final messages = <Uint8List>[];

    // Send first chunk with account index
    {
      final writer = ByteDataWriter();
      final firstChunkSize =
          remainingBytes.length > streamLen ? streamLen : remainingBytes.length;

      final firstChunk = remainingBytes.sublist(0, firstChunkSize);
      remainingBytes = remainingBytes.sublist(firstChunkSize);

      writer.writeUint8(cla); // CLA
      writer.writeUint8(ins); // INS: signTxn
      writer.writeUint8(0x00); // P1: first
      writer.writeUint8(remainingBytes.isEmpty ? 0x00 : 0x80); // P2: more/last

      // Calculate payload size: 4(index) + 4(remaining) + 4(chunk size) + chunk
      writer.writeUint8(12 + firstChunk.length);

      // Write account index (4 bytes)
      writer.writeInt32(accountIndex, Endian.little);

      // Write remaining bytes length (4 bytes)
      writer.writeInt32(remainingBytes.length, Endian.little);

      // Write current chunk size (4 bytes)
      writer.writeInt32(firstChunk.length, Endian.little);

      // Write first chunk of transaction data
      writer.write(firstChunk);

      messages.add(writer.toBytes());
    }

    // Send remaining chunks if any
    while (remainingBytes.isNotEmpty) {
      final writer = ByteDataWriter();
      final chunkSize =
          remainingBytes.length > streamLen ? streamLen : remainingBytes.length;

      final chunk = remainingBytes.sublist(0, chunkSize);
      remainingBytes = remainingBytes.sublist(chunkSize);

      writer.writeUint8(cla); // CLA
      writer.writeUint8(ins); // INS: signTxn
      writer.writeUint8(0x80); // P1: more data
      writer.writeUint8(remainingBytes.isEmpty ? 0x00 : 0x80); // P2: more/last

      // Calculate payload size: 4(remaining) + 4(chunk size) + chunk
      writer.writeUint8(8 + chunk.length);

      // Write remaining bytes length (4 bytes)
      writer.writeInt32(remainingBytes.length, Endian.little);

      // Write current chunk size (4 bytes)
      writer.writeInt32(chunk.length, Endian.little);

      // Write chunk of transaction data
      writer.write(chunk);

      messages.add(writer.toBytes());
    }

    return messages;
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
