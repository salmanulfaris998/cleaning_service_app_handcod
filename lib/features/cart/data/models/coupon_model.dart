class CouponModel {
  final String id;
  final String code;
  final String description;
  final double discountPercent;
  final DateTime validFrom;
  final DateTime validUntil;
  final int maxUses;
  final int usedCount;
  final bool active;

  CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.validFrom,
    required this.validUntil,
    required this.maxUses,
    required this.usedCount,
    required this.active,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    final validFromRaw = json['valid_from'] as String?;
    final validUntilRaw = json['valid_until'] as String?;

    return CouponModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String? ?? '',
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0.0,
      validFrom: validFromRaw != null ? DateTime.parse(validFromRaw) : DateTime.now(),
      validUntil: validUntilRaw != null ? DateTime.parse(validUntilRaw) : DateTime.now(),
      maxUses: json['max_uses'] as int? ?? 0,
      usedCount: json['used_count'] as int? ?? 0,
      active: json['active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discount_percent': discountPercent,
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'max_uses': maxUses,
      'used_count': usedCount,
      'active': active,
    };
  }

  bool get isValid {
    final now = DateTime.now();
    return active &&
        now.isAfter(validFrom) &&
        now.isBefore(validUntil) &&
        usedCount < maxUses;
  }

  double calculateDiscount(double subtotal) {
    return subtotal * (discountPercent / 100);
  }
}
