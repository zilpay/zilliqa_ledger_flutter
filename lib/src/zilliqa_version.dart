/// Represents the version information of the Zilliqa Ledger application
class ZilliqaVersion {
  final int major;
  final int minor;
  final int patch;

  ZilliqaVersion({
    required this.major,
    required this.minor,
    required this.patch,
  });

  /// Get the version code
  int get versionCode => major * 10000 + minor * 100 + patch;

  /// Get the version name formatted as "vX.Y.Z"
  String get versionName => 'v$major.$minor.$patch';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZilliqaVersion &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch;

  @override
  int get hashCode => major.hashCode ^ minor.hashCode ^ patch.hashCode;

  @override
  String toString() => versionName;
}
