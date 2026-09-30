import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/catering_models.dart';
import '../../core/state/catering_state.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final CateringMenu menu;

  const ProductDetailScreen({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int _quantity;
  late String _selectedOption;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _qtyInputController = TextEditingController();
  bool _requestTester = false;

  // Addons
  bool _addMineralWater = false;
  bool _addFruit = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.menu.minOrder;
    _selectedOption = widget.menu.packageOptions.first;
    _qtyInputController.text = '$_quantity';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _qtyInputController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQty) {
    if (newQty < widget.menu.minOrder) {
      newQty = widget.menu.minOrder;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimal pemesanan menu ini adalah ${widget.menu.minOrder} porsi.'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
    setState(() {
      _quantity = newQty;
      _qtyInputController.text = '$_quantity';
    });
  }

  void _showTesterModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.restaurant, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Request Food Tasting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingin mencicipi menu sebelum memesan ratusan porsi untuk hari H?',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '✓ Gratis 1 porsi tester untuk calon pesanan di atas 100 porsi.\n✓ Dikirim H-3 sebelum tanggal acara.',
                style: TextStyle(fontSize: 12, color: AppColors.primaryDark),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _requestTester = true);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tester sample ditambahkan ke formulir pemesanan!')),
              );
            },
            child: const Text('Sertakan Tester'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CateringState();
    final unitPrice = widget.menu.getPriceForQuantity(_quantity);
    final subtotal = unitPrice * _quantity;
    final isFav = state.isFavorite(widget.menu.id);

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image
                Stack(
                  children: [
                    Image.asset(
                      widget.menu.image,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 280,
                        color: AppColors.primarySoft,
                        child: const Center(
                          child: Icon(Icons.fastfood, size: 64, color: AppColors.primary),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: AppColors.textTitle, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: IconButton(
                                    icon: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? AppColors.urgencyRed : AppColors.textTitle,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        state.toggleFavorite(widget.menu.id);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: IconButton(
                                    icon: const Icon(Icons.share_outlined, color: AppColors.textTitle, size: 20),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Tautan menu katering disalin!')),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Floating Badges on image
                    Positioned(
                      bottom: 16,
                      left: 20,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '✓ 100% Halal MUI',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Min. Order ${widget.menu.minOrder} Porsi',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 2. Main Details Body
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        widget.menu.category.toUpperCase(),
                        style: AppTypography.micro.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(widget.menu.name, style: AppTypography.heading1.copyWith(fontSize: 22)),
                      const SizedBox(height: 8),

                      // Rating and Sales
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                          const SizedBox(width: 4),
                          Text('${widget.menu.rating}', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(width: 6),
                          Text('(${widget.menu.reviewCount} ulasan panitia acara)', style: AppTypography.micro),
                          const Spacer(),
                          Text(
                            'Garansi Tepat Waktu',
                            style: AppTypography.micro.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 3. Wholesale Tiered Pricing Table
                      _buildTieredPricingTable(unitPrice),

                      const SizedBox(height: 20),

                      // 4. Description
                      Text('Deskripsi Menu & Rasa', style: AppTypography.heading2),
                      const SizedBox(height: 6),
                      Text(widget.menu.description, style: AppTypography.bodyRegular),

                      const SizedBox(height: 24),

                      // 5. Package Contents Checklist
                      _buildPackageContentsSection(),

                      const SizedBox(height: 24),

                      // 6. Packaging Choice
                      Text('Pilihan Kemasan Wadah:', style: AppTypography.heading2),
                      const SizedBox(height: 10),
                      Column(
                        children: widget.menu.packageOptions.map((opt) {
                          final isSelected = _selectedOption == opt;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedOption = opt),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primarySoft : AppColors.cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      opt,
                                      style: AppTypography.bodyRegular.copyWith(
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                        color: isSelected ? AppColors.primaryDark : AppColors.textTitle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // 7. Large Quantity Stepper & Bulk Presets
                      _buildQuantitySelectorSection(),

                      const SizedBox(height: 20),

                      // 8. Custom Kitchen Notes
                      Text('Catatan Khusus untuk Dapur:', style: AppTypography.heading2),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Pisahkan 15 box tanpa cabai, tempel stiker nama acara...',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 9. Tester Sample Request Button
                      _buildTesterRequestButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Action Dock
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(state, unitPrice, subtotal),
          ),
        ],
      ),
    );
  }

  Widget _buildTieredPricingTable(int currentUnitPrice) {
    final state = CateringState();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.price_check, color: AppColors.primary, size: 20),
              SizedBox(width: 6),
              Text(
                'Tabel Harga Grosir Skala Acara',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTierColumn('10-49 Porsi', state.formatCurrency(widget.menu.basePrice), _quantity < 50),
              const SizedBox(width: 8),
              _buildTierColumn(
                '50-199 Porsi',
                state.formatCurrency(widget.menu.getPriceForQuantity(50)),
                _quantity >= 50 && _quantity < 200,
                badge: 'Hemat 8%',
              ),
              const SizedBox(width: 8),
              _buildTierColumn(
                '200+ Porsi',
                state.formatCurrency(widget.menu.getPriceForQuantity(200)),
                _quantity >= 200,
                badge: 'Hemat 17%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierColumn(String range, String price, bool isActive, {String? badge}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.borderSubtle,
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Column(
          children: [
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : AppColors.urgencyAmberSoft,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primary : AppColors.urgencyAmber,
                  ),
                ),
              ),
            Text(
              range,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white70 : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              price,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.white : AppColors.textTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageContentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Rincian Isi per Porsi/Box:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.menu.packageContents.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item, style: AppTypography.bodyRegular.copyWith(fontSize: 13)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildQuantitySelectorSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jumlah Porsi Pesanan:', style: AppTypography.heading2),
              Text(
                'Min. ${widget.menu.minOrder} porsi',
                style: AppTypography.micro.copyWith(color: AppColors.urgencyAmber, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stepper + Direct input
          Row(
            children: [
              _buildStepperButton(Icons.remove, () => _updateQuantity(_quantity - 5)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _qtyInputController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: AppTypography.heading1.copyWith(color: AppColors.primary),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (val) {
                        final parsed = int.tryParse(val);
                        if (parsed != null) _updateQuantity(parsed);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildStepperButton(Icons.add, () => _updateQuantity(_quantity + 5)),
            ],
          ),
          const SizedBox(height: 12),
          // Bulk Presets
          Text('Preset Cepat Porsi Acara:', style: AppTypography.micro),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [25, 50, 100, 200, 500].map((preset) {
              final isMatch = _quantity == preset;
              return ActionChip(
                label: Text('$preset porsi', style: TextStyle(fontSize: 12, fontWeight: isMatch ? FontWeight.bold : FontWeight.normal)),
                backgroundColor: isMatch ? AppColors.primary : AppColors.surfaceSoft,
                labelStyle: TextStyle(color: isMatch ? Colors.white : AppColors.textBody),
                side: BorderSide(color: isMatch ? AppColors.primary : AppColors.borderSubtle),
                onPressed: () => _updateQuantity(preset),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Icon(icon, color: AppColors.textTitle, size: 20),
      ),
    );
  }

  Widget _buildTesterRequestButton() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _requestTester ? AppColors.successSoft : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _requestTester ? AppColors.success : AppColors.primaryLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _requestTester ? Icons.check_circle : Icons.lunch_dining_outlined,
            color: _requestTester ? AppColors.success : AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _requestTester ? 'Tester Sample Disertakan (H-3)' : 'Perlu Food Tasting / Sample Tester?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _requestTester ? Color(0xFF065F46) : AppColors.primaryDark,
                  ),
                ),
                Text(
                  _requestTester ? 'Tester gratis 1 porsi akan dikirim sebelum acara.' : 'Gratis untuk pesanan diatas 100 porsi.',
                  style: const TextStyle(fontSize: 11, color: AppColors.textBody),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showTesterModal(context),
            child: Text(_requestTester ? 'Ubah' : 'Minta Tester'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CateringState state, int unitPrice, int subtotal) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total ($_quantity porsi):', style: AppTypography.micro),
              Text(
                state.formatCurrency(subtotal),
                style: AppTypography.heading1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              Text(
                '@${state.formatCurrency(unitPrice)}/porsi',
                style: AppTypography.micro.copyWith(fontSize: 10),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                state.addToCart(
                  menu: widget.menu,
                  selectedOption: _selectedOption,
                  portionCount: _quantity,
                  notes: _notesController.text,
                  requestTester: _requestTester,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$_quantity porsi ${widget.menu.name} ditambahkan ke Keranjang!'),
                    action: SnackBarAction(
                      label: 'Lihat Keranjang',
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                  ),
                );

                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_shopping_cart, size: 18),
                  SizedBox(width: 6),
                  Text('Tambah ke Keranjang', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
