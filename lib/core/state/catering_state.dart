import 'package:flutter/material.dart';
import '../../models/catering_models.dart';

class CateringState extends ChangeNotifier {
  static final CateringState _instance = CateringState._internal();
  factory CateringState() => _instance;
  CateringState._internal() {
    _initSampleData();
  }

  // User Profile
  String userName = 'Ahmad Pratama';
  String userEmail = 'ahmad.pratama@student.ui.ac.id';
  String userPhone = '081234567890';
  String userOrganization = 'BEM Universitas Indonesia • Dept. Danus & Bisnis';
  String selectedVenue = 'Gedung Rektorat & Auditorium UI Depok';
  String eventDate = '14 November 2026';
  String eventTime = '11:30 WIB';
  bool isLoggedIn = true;

  // Catalog
  List<CateringMenu> menus = [];
  Set<String> favoriteIds = {'m1', 'm2'};

  // Cart
  List<CartItem> cart = [];

  // Orders
  List<CateringOrder> orders = [];

  // Filter & Search
  String activeCategory = 'Semua';
  String searchQuery = '';

  void _initSampleData() {
    menus = [
      const CateringMenu(
        id: 'm1',
        name: 'Nasi Kotak Bento Ayam Bakar Madu',
        category: 'Nasi Kotak & Bento',
        image: 'assets/images/nasi_kuning.jpg',
        basePrice: 24000,
        minOrder: 15,
        rating: 4.9,
        reviewCount: 384,
        isBestSeller: true,
        isHalal: true,
        description: 'Paket bento komplit favorit panitia acara kampus dan seminar. Diracik dengan bumbu rempah madu bakar meresap hingga ke tulang, disajikan dalam kemasan bento sekat tebal mewah.',
        packageContents: [
          'Nasi Kuning / Gurih Pulen Premium',
          'Ayam Bakar Madu Potong 4 (Paha / Dada)',
          'Telur Balado Balut Cabai Segar',
          'Orek Tempe Kering Manis Gurih',
          'Sambal Terasi Jeruk Limau',
          'Lalapan Timun & Kemangi Segar',
          'Sendok Set, Tisu Higienis & Tusuk Gigi',
        ],
        packageOptions: [
          'Bento Box Sekat 4 (Paling Populer)',
          'Box Ivory Eco-Friendly',
          'Besek Tradisional Daun Pisang (+Rp 3.000)',
        ],
        tieredPricing: {
          '15-49': 24000,
          '50-199': 22500,
          '200+': 21000,
        },
      ),
      const CateringMenu(
        id: 'm2',
        name: 'Paket Danus Risoles Mayo Beef Lumer',
        category: 'Paket Danus Mahasiswa',
        image: 'assets/images/risoles.jpg',
        basePrice: 10000,
        minOrder: 20,
        rating: 4.9,
        reviewCount: 512,
        isBestSeller: true,
        isHalal: true,
        description: 'Pilihan nomor satu untuk tim Dana Usaha (Danus) kampus! Harga modal grosir sangat murah dengan potensi laba hingga 50-70% saat dijual kembali di lorong fakultas atau acara kampus.',
        packageContents: [
          'Kulit Risol Lembut dengan Tepung Roti Emas',
          'Isian Smoked Beef Premium Asli',
          'Telur Rebus Potong Segar',
          'Mayones Creamy Rahasia Meleleh',
          'Cabai Rawit Hijau Segar per Pcs',
          'Kemasan Plastik Mika / Box Danus Sablon',
        ],
        packageOptions: [
          'Matang Siap Santap Hangat',
          'Frozen Pack (Tahan 1 Bulan)',
          'Kemasan Box Satuan Mika',
        ],
        tieredPricing: {
          '20-49': 10000,
          '50-199': 9000,
          '200+': 8200,
        },
      ),
      const CateringMenu(
        id: 'm3',
        name: 'Snack Box Rapat Eksekutif Lumpia Diego',
        category: 'Snack Box Rapat',
        image: 'assets/images/lumpia.jpg',
        basePrice: 16000,
        minOrder: 15,
        rating: 4.8,
        reviewCount: 220,
        isBestSeller: false,
        isHalal: true,
        description: 'Snack box formal untuk coffee break rapat dekanat, sidang skripsi, rapat BEM, atau tamu VIP. Kombinasi pas manis dan gurih dengan saus khas Diego.',
        packageContents: [
          'Lumpia Goreng Crispy Diego Isi Rebung & Ayam',
          'Saus Tauco Manis Pedas Khas',
          'Kue Lapis Legit Pandan Mini',
          'Air Mineral Gelas 220ml',
          'Kotak Box Hard Kraft Eksklusif',
        ],
        packageOptions: [
          'Box Kraft Coklat Ramah Lingkungan',
          'Box Putih Bersih Formal',
          'Tambahan Buah Pisang Sunpride (+Rp 2.500)',
        ],
        tieredPricing: {
          '15-49': 16000,
          '50-199': 14800,
          '200+': 13500,
        },
      ),
      const CateringMenu(
        id: 'm4',
        name: 'Paket Danus Martabak Mini Manis Toping Mix',
        category: 'Paket Danus Mahasiswa',
        image: 'assets/images/martabak.jpg',
        basePrice: 12000,
        minOrder: 25,
        rating: 4.8,
        reviewCount: 198,
        isBestSeller: false,
        isHalal: true,
        description: 'Camilan manis bertekstur empuk bersarang dengan toping melimpah. Cocok untuk danusan harian atau snack penutup acara malam keakraban.',
        packageContents: [
          'Martabak Mini Cokelat Meises Lumer',
          'Martabak Mini Keju Cheddar Parut Tebal',
          'Martabak Mini Kacang Karamel',
          'Susu Kental Manis Asli',
        ],
        packageOptions: [
          'Isi 3 Pcs per Box Mika',
          'Isi 4 Pcs Campur Komplit',
        ],
        tieredPricing: {
          '25-49': 12000,
          '50-199': 10500,
          '200+': 9500,
        },
      ),
      const CateringMenu(
        id: 'm5',
        name: 'Donat Kentang Salju Klasik Mahasiswa',
        category: 'Snack Box Rapat',
        image: 'assets/images/donat.jpg',
        basePrice: 8500,
        minOrder: 20,
        rating: 4.7,
        reviewCount: 165,
        isBestSeller: false,
        isHalal: true,
        description: 'Donat kentang asli super lembut, dibuat segar di hari pengantaran tanpa bahan pengawet. Bertabur gula halus dingin salju yang tidak enek.',
        packageContents: [
          'Donat Kentang Tebal Mengembang Empuk',
          'Taburan Gula Salju Halus Higienis',
          'Kertas Alas Roti Food Grade',
        ],
        packageOptions: [
          'Kemasan Satuan Plastik Seal',
          'Box Isi 6 Pcs Acara',
        ],
        tieredPricing: {
          '20-49': 8500,
          '50-199': 7500,
          '200+': 6800,
        },
      ),
      const CateringMenu(
        id: 'm6',
        name: 'Paket Prasmanan Buffet Akbar Nusantara',
        category: 'Prasmanan & Buffet',
        image: 'assets/images/banner_sale.jpg',
        basePrice: 48000,
        minOrder: 50,
        rating: 5.0,
        reviewCount: 89,
        isBestSeller: true,
        isHalal: true,
        description: 'Layanan prasmanan lengkap untuk Dies Natalis, Wisuda, Resepsi, atau Seminar Nasional. Sudah termasuk pemanas chaffer dish, perlengkapan makan, taplak meja, dan pramusaji standby.',
        packageContents: [
          'Nasi Putih Wangi & Nasi Liwet Teri Medan',
          'Ayam Bakar Bumbu Rujak / Daging Rendang Padang',
          'Sup Kimlo / Sup Buntut Rempah Hangat',
          'Ikan Gurame Fillet Asam Manis',
          'Tumis Buncis Daging Cincang / Capcay Seafood',
          'Kerupuk Udang, Sambal Bajak & Lalap',
          'Puding Cokelat Vla Vanila & Buah Potong Segar',
          'Es Kelapa Jeruk Selasih & Air Mineral',
          'Termasuk Meja Prasmanan, Piring Sendok & 2 Waiter',
        ],
        packageOptions: [
          'Menu Standar Nusantara (Lengkap)',
          'Menu VIP Tambahan Daging Sapi Lada Hitam (+Rp 12.000/porsi)',
        ],
        tieredPricing: {
          '50-99': 48000,
          '100-299': 44500,
          '300+': 41000,
        },
      ),
    ];

    // Seed realistic active & past orders
    orders = [
      CateringOrder(
        id: 'PO-KTG-8821',
        eventName: 'Seminar Nasional UI Tech Expo 2026',
        eventDate: '18 Oktober 2026',
        eventTime: '11:30 WIB',
        deliveryAddress: 'Auditorium Gedung B, Fakultas Teknik UI, Depok',
        contactName: 'Ahmad Pratama',
        contactPhone: '081234567890',
        notes: 'Minta diantar tepat pukul 11:00 WIB agar siap saat istirahat zuhur. 15 porsi tanpa sambal.',
        items: [
          CartItem(
            menu: menus[0],
            selectedOption: 'Bento Box Sekat 4 (Paling Populer)',
            portionCount: 120,
          ),
          CartItem(
            menu: menus[2],
            selectedOption: 'Box Kraft Coklat Ramah Lingkungan',
            portionCount: 120,
          ),
        ],
        subtotal: (120 * 22500) + (120 * 14800), // 2.700.000 + 1.776.000 = 4.476.000
        discount: 250000,
        deliveryFee: 0, // Free delivery for catering > 1jt
        serviceFee: 5000,
        total: 4231000,
        dpAmount: 2115500,
        isFullPayment: false,
        status: OrderStatus.prosesMasak,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CateringOrder(
        id: 'PO-KTG-7914',
        eventName: 'Danusan Rapat Pleno BEM UI',
        eventDate: '28 September 2026',
        eventTime: '16:00 WIB',
        deliveryAddress: 'Selasar Gedung Pusgiwa UI Depok',
        contactName: 'Ahmad Pratama',
        contactPhone: '081234567890',
        notes: 'Pesanan sudah diterima hangat dan ludes terjual.',
        items: [
          CartItem(
            menu: menus[1],
            selectedOption: 'Matang Siap Santap Hangat',
            portionCount: 80,
          ),
        ],
        subtotal: 80 * 9000, // 720.000
        discount: 0,
        deliveryFee: 15000,
        serviceFee: 5000,
        total: 740000,
        dpAmount: 740000,
        isFullPayment: true,
        status: OrderStatus.selesai,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  // Favorite toggle
  void toggleFavorite(String menuId) {
    if (favoriteIds.contains(menuId)) {
      favoriteIds.remove(menuId);
    } else {
      favoriteIds.add(menuId);
    }
    notifyListeners();
  }

  bool isFavorite(String menuId) => favoriteIds.contains(menuId);

  // Cart operations
  int get totalCartPortions => cart.fold(0, (sum, item) => sum + item.portionCount);
  int get totalCartSubtotal => cart.fold(0, (sum, item) => sum + item.subtotal);
  int get estimatedDeliveryFee => totalCartSubtotal >= 500000 ? 0 : 25000;
  int get volumeDiscount {
    if (totalCartPortions >= 200) return (totalCartSubtotal * 0.10).toInt();
    if (totalCartPortions >= 100) return (totalCartSubtotal * 0.05).toInt();
    return 0;
  }
  int get serviceFee => 5000;
  int get grandTotal => totalCartSubtotal - volumeDiscount + estimatedDeliveryFee + serviceFee;
  int get dpAmount => (grandTotal * 0.50).toInt();

  void addToCart({
    required CateringMenu menu,
    required String selectedOption,
    required int portionCount,
    String notes = '',
    bool requestTester = false,
  }) {
    final existingIndex = cart.indexWhere(
      (item) => item.menu.id == menu.id && item.selectedOption == selectedOption,
    );

    if (existingIndex >= 0) {
      cart[existingIndex].portionCount += portionCount;
      if (notes.isNotEmpty) cart[existingIndex].notes = notes;
      if (requestTester) cart[existingIndex].requestTester = true;
    } else {
      cart.add(CartItem(
        menu: menu,
        selectedOption: selectedOption,
        portionCount: portionCount,
        notes: notes,
        requestTester: requestTester,
      ));
    }
    notifyListeners();
  }

  void updateCartItemQuantity(int index, int newQty) {
    if (index >= 0 && index < cart.length) {
      if (newQty <= 0) {
        cart.removeAt(index);
      } else {
        cart[index].portionCount = newQty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < cart.length) {
      cart.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  // Create Catering Order from Cart
  CateringOrder createOrder({
    required String eventName,
    required String eventDate,
    required String eventTime,
    required String deliveryAddress,
    required String contactName,
    required String contactPhone,
    required String notes,
    required bool isFullPayment,
  }) {
    final orderId = 'PO-KTG-${1000 + (DateTime.now().millisecondsSinceEpoch % 9000)}';
    final newOrder = CateringOrder(
      id: orderId,
      eventName: eventName,
      eventDate: eventDate,
      eventTime: eventTime,
      deliveryAddress: deliveryAddress,
      contactName: contactName,
      contactPhone: contactPhone,
      notes: notes,
      items: List.from(cart),
      subtotal: totalCartSubtotal,
      discount: volumeDiscount,
      deliveryFee: estimatedDeliveryFee,
      serviceFee: serviceFee,
      total: grandTotal,
      dpAmount: isFullPayment ? grandTotal : dpAmount,
      isFullPayment: isFullPayment,
      status: OrderStatus.menungguKonfirmasi,
      createdAt: DateTime.now(),
    );

    orders.insert(0, newOrder);
    clearCart();
    notifyListeners();
    return newOrder;
  }

  String formatCurrency(int amount) {
    final s = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  // Generate WhatsApp Purchase Order formatted string
  String generateWhatsAppMessage(CateringOrder order) {
    final buf = StringBuffer();
    buf.writeln('📋 *FORMULIR PEMESANAN KATERING (PURCHASE ORDER)*');
    buf.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buf.writeln('*No. Pesanan:* ${order.id}');
    buf.writeln('*Waktu Pesan:* ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}');
    buf.writeln('');
    buf.writeln('📌 *DETAIL ACARA & PENGANTARAN*');
    buf.writeln('• *Nama Acara:* ${order.eventName}');
    buf.writeln('• *Tanggal Acara:* ${order.eventDate}');
    buf.writeln('• *Jam Standby Katering:* ${order.eventTime}');
    buf.writeln('• *Lokasi Pengiriman:* ${order.deliveryAddress}');
    buf.writeln('• *Nama PIC:* ${order.contactName}');
    buf.writeln('• *No. WhatsApp PIC:* ${order.contactPhone}');
    if (order.notes.isNotEmpty) {
      buf.writeln('• *Catatan Dapur:* ${order.notes}');
    }
    buf.writeln('');
    buf.writeln('🍱 *RINCIAN MENU KATERING*');
    for (int i = 0; i < order.items.length; i++) {
      final item = order.items[i];
      buf.writeln('${i + 1}. *${item.menu.name}*');
      buf.writeln('   - Kemasan: ${item.selectedOption}');
      buf.writeln('   - Jumlah: ${item.portionCount} porsi @ ${formatCurrency(item.unitPrice)}');
      buf.writeln('   - Subtotal: ${formatCurrency(item.subtotal)}');
      if (item.notes.isNotEmpty) {
        buf.writeln('   - Request: ${item.notes}');
      }
      if (item.requestTester) {
        buf.writeln('   - [✓] Mohon sertakan Tester Sample H-3');
      }
    }
    buf.writeln('');
    buf.writeln('💳 *RINCIAN BIAYA & SKEMA PEMBAYARAN*');
    buf.writeln('• Subtotal Menu: ${formatCurrency(order.subtotal)}');
    if (order.discount > 0) {
      buf.writeln('• Diskon Katering Skala Besar: -${formatCurrency(order.discount)}');
    }
    buf.writeln('• Ongkir Mobil Box Katering: ${order.deliveryFee == 0 ? "GRATIS" : formatCurrency(order.deliveryFee)}');
    buf.writeln('• Biaya Penanganan & Kemasan: ${formatCurrency(order.serviceFee)}');
    buf.writeln('-------------------------------------');
    buf.writeln('*TOTAL TAGIHAN:* ${formatCurrency(order.total)}');
    buf.writeln('*Skema Bayar:* ${order.isFullPayment ? "Pelunasan 100%" : "Uang Muka (DP 50%)"}');
    buf.writeln('*Nominal Tagihan Awal:* *${formatCurrency(order.dpAmount)}*');
    buf.writeln('');
    buf.writeln('🏦 *REKENING PEMBAYARAN RESMI:*');
    buf.writeln('Bank BCA: 8820-1928-11 a.n. PT KateringKita Nusantara');
    buf.writeln('Bank Mandiri: 157-00-9922-111 a.n. KateringKita Indonesia');
    buf.writeln('QRIS: Tersedia di Kasir / Faktur Invoice');
    buf.writeln('');
    buf.writeln('Mohon konfirmasi ketersediaan slot dapur dan jadwal pengantaran. Terima kasih!');
    return buf.toString();
  }
}
