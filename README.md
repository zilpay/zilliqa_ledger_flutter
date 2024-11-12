<div align="center">
  <a href="https://www.ledger.com/">
    <img src="https://cdn.freebiesupply.com/logos/large/2x/ledger-logo-png-transparent.png" width="600"/>
  </a>

<h1 align="center">ledger-zilliqa</h1>

<p align="center">
    A Flutter Ledger App Plugin for the Zilliqa blockchain
    <br />
    <a href="https://pub.dev/documentation/zilliqa_ledger_flutter/latest/"><strong>« Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/zilpay/zilliqa_ledger_flutter/issues">Report Bug</a>
    · <a href="https://github.com/zilpay/zilliqa_ledger_flutter/issues">Request Feature</a>
    · <a href="https://pub.dev/packages/ledger_flutter">Ledger Flutter</a>
  </p>
</div>
<br/>

---

## Overview

Ledger Nano devices provide secure hardware wallet solutions for managing your cryptocurrencies. This Flutter package is a plugin for the [ledger_flutter](https://pub.dev/packages/ledger_flutter) package that enables interaction with the Zilliqa blockchain, allowing you to retrieve accounts and sign transactions using your Ledger hardware wallet.

## Features

- 🔑 Get public keys and addresses
- 📝 Sign transactions
- 🔐 Sign message hashes
- 📱 Cross-platform support (iOS & Android)
- ⚡️ Fast and efficient BLE communication
- 🔒 Secure transaction signing

## Getting Started

### Installation

Add the latest version of this package to your `pubspec.yaml`:

```yaml
dependencies:
  zilliqa_ledger_flutter: ^latest-version
```

For integration with the Ledger Flutter package, check out the documentation [here](https://pub.dev/packages/ledger_flutter).

### Setup

Create a new instance of a `ZilliqaLedgerApp` and pass an instance of your `Ledger` object:

```dart
final app = ZilliqaLedgerApp(ledger);
```

## Usage

### Get Public Key and Address

You can retrieve the public key and address for a specific account index:

```dart
// Get public key
final publicKey = await app.getPublicKey(device, accountIndex);

// Get public address
final addressInfo = await app.getPublicAddress(device, accountIndex);
print('Address: ${addressInfo.address}');
print('Public Key: ${addressInfo.publicKey}');
```

### Sign Transactions

Sign Zilliqa transactions using your Ledger device:

```dart
// Prepare your transaction bytes
final transaction = // Your encoded transaction bytes

final signature = await app.signZilliqaTransaction(
    device,
    transaction,
    accountIndex,
);

// Use the signature with your transaction
print('Transaction signature: $signature');
```

### Sign Message Hash

Sign message hashes for verification:

```dart
final hash = // Your message hash bytes
final signature = await app.signHash(
    device,
    hash,
    accountIndex,
);

print('Message signature: $signature');
```

## Error Handling

The plugin includes comprehensive error handling for common Ledger operations:

```dart
try {
  final publicKey = await app.getPublicKey(device, accountIndex);
} catch (e) {
  if (e is LedgerException) {
    // Handle Ledger-specific errors
    print('Ledger error: ${e.message}');
  } else {
    // Handle other errors
    print('Error: $e');
  }
}
```

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag `enhancement`.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'feat: add some amazing feature'`)
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

The zilliqa_ledger_flutter package is released under the MIT License. See [LICENSE](LICENSE) for details.

## Support

If you like this package, consider supporting it by:
- ⭐️ Starring the repository
- 🐛 Reporting bugs
- 📝 Contributing to the codebase
- 💡 Suggesting new featuresrom the package authors, and more.
