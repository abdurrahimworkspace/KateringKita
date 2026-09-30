import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/state/catering_state.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = CateringState();

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.bgMain,
          appBar: AppBar(
            title: const Text('Keranjang Katering Acara'),
            actions: [
              if (state.cart.isNotEmpty)
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Kosongkan Keranjang?'),
                        content: const Text('Semua menu katering yang dipilih akan dihapus dari keranjang.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                          ElevatedButton(
                            onPressed: () {
                              state.clearCart();
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.urgencyRed),
                            child: const Text('Kosongkan'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Kosongkan', style: TextStyle(color: AppColors.urgencyRed)),
                ),
            ],
          ),
          body: state.cart.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartList(context, state),
          bottomNavigationBar: state.cart.isEmpty ? null : _buildCheckoutBar(context, state),
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 52),
            ),
            const SizedBox(height: 20),
            Text('Keranjang Masih Kosong', style: AppTypography.heading1),
            const SizedBox(height: 8),
            Text(
              'Belum ada paket katering atau snack box yang dipilih untuk acaramu.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Pilih Menu Katering Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CateringState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Summary Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_available, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemesanan Acara: ${state.selectedVenue}',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Jadwal Tiba: ${state.eventDate} • ${state.eventTime}',
                        style: AppTypography.micro.copyWith(color: AppColors.textBody),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Daftar Menu Acara (${state.cart.length} Jenis Menu)', style: AppTypography.heading2),
          const SizedBox(height: 12),

          // Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.cart.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = state.cart[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item.menu.image,
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 65,
                              height: 65,
                              color: AppColors.primarySoft,
                              child: const Icon(Icons.fastfood, color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.menu.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 3),
                              Text(
                                'Kemasan: ${item.selectedOption}',
                                style: AppTypography.micro.copyWith(color: AppColors.textMuted, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${state.formatCurrency(item.unitPrice)} / porsi',
                                style: AppTypography.bodyRegular.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.textMuted, size: 20),
                          onPressed: () => state.removeFromCart(index),
                        ),
                      ],
                    ),

                    if (item.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Catatan: ${item.notes}',
                          style: AppTypography.micro.copyWith(fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: 10),

                    // Quantity Stepper inside Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal: ${state.formatCurrency(item.subtotal)}', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            _buildMiniQtyBtn(Icons.remove, () {
                              state.updateCartItemQuantity(index, item.portionCount - 5);
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item.portionCount} porsi',
                                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildMiniQtyBtn(Icons.add, () {
                              state.updateCartItemQuantity(index, item.portionCount + 5);
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Volume Discount Banner
          if (state.totalCartPortions >= 50)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.success.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Selamat! Pesananmu (${state.totalCartPortions} porsi) memenuhi syarat Diskon Skala Akbar & Gratis Ongkir Mobil Box!',
                      style: AppTypography.micro.copyWith(color: Color(0xFF065F46), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Icon(icon, size: 16, color: AppColors.textTitle),
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CateringState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              Text('${state.totalCartPortions} Porsi Katering', style: AppTypography.micro),
              Text(
                state.formatCurrency(state.grandTotal),
                style: AppTypography.heading1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Lanjut ke Checkout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
