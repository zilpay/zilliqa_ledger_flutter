import 'dart:typed_data';
import 'package:ledger_flutter/ledger_flutter.dart';
import 'package:zilpay/ledger/src/operations/zilliqa_public_address_operation.dart';
import 'package:zilpay/ledger/src/operations/zilliqa_public_key_operation.dart';
import 'package:zilpay/ledger/src/operations/zilliqa_sign_hash_operation.dart';
import 'package:zilpay/ledger/src/operations/zilliqa_sign_transaction_operation.dart';
import 'package:zilpay/ledger/src/operations/zilliqa_version_operation.dart';
import 'zilliqa_version.dart';
import 'zilliqa_transformer.dart';

/// A [LedgerApp] used to perform BLE operations on a ledger [Zilliqa]
/// application.
class ZilliqaLedgerApp extends LedgerApp {
  static const errorExecution = 0x6400;
  static const errorEmptyBuffer = 0x6982;
  static const errorOutputBufferTooSmall = 0x6983;
  static const errorCommandNotAllowed = 0x6986;
  static const errorInsNotSupported = 0x6D00;
  static const errorClaNotSupported = 0x6E00;
  static const errorUnknown = 0x6F00;
  static const success = 0x8000;

  // Constants from JS implementation
  static const pubKeyByteLen = 33;
  static const sigByteLen = 64;
  static const hashByteLen = 32;
  static const bech32AddrLen = 39; // 'zil'.length + 1 + 32 + 6

  int accountIndex;
  LedgerTransformer? transformer;

  ZilliqaLedgerApp(
    super.ledger, {
    this.accountIndex = 0,
    this.transformer = const ZilliqaTransformer(),
  });

  @override
  Future<ZilliqaVersion> getVersion(LedgerDevice device) {
    return ledger.sendOperation<ZilliqaVersion>(
      device,
      ZilliqaVersionOperation(),
      transformer: transformer,
    );
  }

  /// Gets the public key for the specified account index
  Future<String> getPublicKey(LedgerDevice device, [int? index]) async {
    final response = await ledger.sendOperation<String>(
      device,
      ZilliqaPublicKeyOperation(index ?? accountIndex),
      transformer: transformer,
    );
    return response;
  }

  /// Gets the public address for the specified account index
  Future<({String publicKey, String address})> getPublicAddress(
      LedgerDevice device,
      [int? index]) async {
    final response =
        await ledger.sendOperation<({String publicKey, String address})>(
      device,
      ZilliqaPublicAddressOperation(index ?? accountIndex),
      transformer: transformer,
    );
    return response;
  }

  @override
  Future<List<Uint8List>> signTransactions(
    LedgerDevice device,
    List<Uint8List> transactions,
  ) async {
    // TODO: implement signTransaction
    return [];
  }

  /// Signs a transaction using the specified account index
  Future<String> signZilliqaTransaction(
      LedgerDevice device, Uint8List transaction, int? index) async {
    final signature = await ledger.sendOperation<String>(
      device,
      ZilliqaSignTransactionOperation(
        index ?? accountIndex,
        transaction,
      ),
      transformer: transformer,
    );
    return signature;
  }

  /// Signs a message hash using the specified account index
  Future<String> signHash(
    LedgerDevice device,
    Uint8List hash, [
    int? index,
  ]) async {
    final signature = await ledger.sendOperation<String>(
      device,
      ZilliqaSignHashOperation(
        index ?? accountIndex,
        Uint8List.fromList(hash),
      ),
      transformer: transformer,
    );
    return signature;
  }

  @override
  Future<List<String>> getAccounts(LedgerDevice device) {
    // TODO: implement getAccounts
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> signTransaction(
      LedgerDevice device, Uint8List transaction) {
    // TODO: implement signTransaction
    throw UnimplementedError();
  }
}
