import 'dart:typed_data';
import 'package:ledger_flutter/ledger_flutter.dart';
import 'package:zilliqa_ledger_flutter/zilliqa_ledger_flutter.dart';

Future<void> main() async {
  final options = LedgerOptions(
    maxScanDuration: const Duration(
      milliseconds: 5000,
    ),
  );

  // Initialize Ledger
  final ledger = Ledger(options: options);

  try {
    // Get list of available devices
    final device = ledger.devices[0];

    try {
      // Connect to the device
      await ledger.connect(device);
    } catch (e) {
      print("Failed to connect to device: $e");
      return;
    }

    // Initialize Zilliqa app
    final ledgerZilliqa = ZilliqaLedgerApp(ledger);

    // Get app version
    try {
      final version = await ledgerZilliqa.getVersion(device);
      print('App Version: $version');
    } catch (e) {
      print('Failed to get version: $e');
    }

    // Get public address for index 1
    try {
      final data = await ledgerZilliqa.getPublicAddress(device, 1);
      print('Public Key: ${data.publicKey}');
      print('Address: ${data.address}');
    } catch (e) {
      print('Failed to get public address: $e');
    }

    // Test hash signing
    try {
      // Example fixed test hash
      final hash = Uint8List.fromList([
        0x01,
        0x23,
        0x45,
        0x67,
        0x89,
        0xab,
        0xcd,
        0xef,
        0xfe,
        0xdc,
        0xba,
        0x98,
        0x76,
        0x54,
        0x32,
        0x10,
        0x00,
        0x11,
        0x22,
        0x33,
        0x44,
        0x55,
        0x66,
        0x77,
        0x88,
        0x99,
        0xaa,
        0xbb,
        0xcc,
        0xdd,
        0xee,
        0xff
      ]);

      final signedHash = await ledgerZilliqa.signHash(device, hash, 1);
      print('Signed Hash: $signedHash');
    } catch (e) {
      print('Failed to sign hash: $e');
    }

    // Test transaction signing
    try {
      // Example encoded transaction (you should replace this with your actual encoded transaction)
      final encodedTx = Uint8List.fromList([
        // Your encoded transaction bytes here
        0x01, 0x02, 0x03, // ... example bytes
      ]);

      final signature =
          await ledgerZilliqa.signZilliqaTransaction(device, encodedTx, 1);
      print('Transaction Signature: $signature');
    } catch (e) {
      print('Failed to sign transaction: $e');
    }
  } catch (e) {
    print('Unexpected error: $e');
  } finally {}
}
