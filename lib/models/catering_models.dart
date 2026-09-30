import 'package:flutter/material.dart';

enum OrderStatus {
  menungguKonfirmasi,
  dpDiterima,
  prosesMasak,
  pengantaran,
  selesai,
  dibatalkan,
}

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.menungguKonfirmasi:
        return 'Menunggu Konfirmasi DP';
      case OrderStatus.dpDiterima:
        return 'DP Diterima • Dijadwalkan';
      case OrderStatus.prosesMasak:
        return 'Sedang Dimasak di Dapur';
      case OrderStatus.pengantaran:
        return 'Dalam Pengiriman Kurir Katering';
      case OrderStatus.selesai:
        return 'Selesai & Lunas';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.menungguKonfirmasi:
        return const Color(0xFFF59E0B);
      case OrderStatus.dpDiterima:
        return const Color(0xFF3B82F6);
      case OrderStatus.prosesMasak:
        return const Color(0xFFFF5722);
      case OrderStatus.pengantaran:
        return const Color(0xFF8B5CF6);
      case OrderStatus.selesai:
        return const Color(0xFF10B981);
      case OrderStatus.dibatalkan:
        return const Color(0xFFEF4444);
    }
  }
}

class CateringMenu {
  final String id;
  final String name;
  final String category; // 'Nasi Kotak & Bento', 'Snack Box Rapat', 'Paket Danus Mahasiswa', 'Prasmanan & Buffet'
  final String image;
  final int basePrice;
  final int minOrder;
  final String description;
  final double rating;
  final int reviewCount;
  final bool isBestSeller;
  final bool isHalal;
  final List<String> packageContents;
  final List<String> packageOptions;
  final Map<String, int> tieredPricing; // e.g. {'10-49': 22000, '50-199': 20000, '200+': 18500}

  const CateringMenu({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.basePrice,
    this.minOrder = 10,
    required this.description,
    this.rating = 4.9,
    this.reviewCount = 120,
    this.isBestSeller = false,
    this.isHalal = true,
    required this.packageContents,
    required this.packageOptions,
    required this.tieredPricing,
  });

  int getPriceForQuantity(int qty) {
    if (qty >= 200 && tieredPricing.containsKey('200+')) {
      return tieredPricing['200+']!;
    } else if (qty >= 50 && tieredPricing.containsKey('50-199')) {
      return tieredPricing['50-199']!;
    }
    return basePrice;
  }
}

class CartItem {
  final CateringMenu menu;
  String selectedOption;
  int portionCount;
  String notes;
  bool requestTester;

  CartItem({
    required this.menu,
    required this.selectedOption,
    required this.portionCount,
    this.notes = '',
    this.requestTester = false,
  });

  int get unitPrice => menu.getPriceForQuantity(portionCount);
  int get subtotal => unitPrice * portionCount;
}

class CateringOrder {
  final String id;
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String deliveryAddress;
  final String contactName;
  final String contactPhone;
  final String notes;
  final List<CartItem> items;
  final int subtotal;
  final int discount;
  final int deliveryFee;
  final int serviceFee;
  final int total;
  final int dpAmount;
  final bool isFullPayment;
  final OrderStatus status;
  final DateTime createdAt;

  CateringOrder({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.deliveryAddress,
    required this.contactName,
    required this.contactPhone,
    this.notes = '',
    required this.items,
    required this.subtotal,
    this.discount = 0,
    this.deliveryFee = 0,
    this.serviceFee = 5000,
    required this.total,
    required this.dpAmount,
    this.isFullPayment = false,
    this.status = OrderStatus.menungguKonfirmasi,
    required this.createdAt,
  });
}
