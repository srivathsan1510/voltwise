class SmartDevice {
  final String id;
  final String name;
  final String iconAsset;
  final double kwhUsage;
  final bool isSafe;

  SmartDevice({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.kwhUsage,
    this.isSafe = true,
  });
}