import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/catering_models.dart';
import '../../core/state/catering_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Semua', 'Aktif / Masak', 'Selesai'];

  Future<void> _contactAdminWhatsApp(String orderId) async {
    const adminPhone = '6281234567890';
    final text = Uri.encodeComponent('Halo Admin KateringKita, saya ingin menanyakan status pesanan katering nomor *$orderId*.');
    final uri = Uri.parse('https://wa.me/$adminPhone?text=$text');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _showOrderDetailSheet(BuildContext context, CateringOrder order) {
    final state = CateringState();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Detail Pesanan Katering', style: AppTypography.heading1),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.status.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status.label,
                      style: TextStyle(color: order.status.color, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('No. PO: ${order.id}', style: AppTypography.micro.copyWith(fontWeight: FontWeight.bold)),
              Text('Nama Acara: ${order.eventName}', style: AppTypography.heading2),
              const SizedBox(height: 4),
              Text('Jadwal: ${order.eventDate} • ${order.eventTime}', style: AppTypography.bodyRegular),
              Text('Lokasi: ${order.deliveryAddress}', style: AppTypography.bodyRegular),
              const Divider(height: 24, color: AppColors.borderSubtle),
              Text('Daftar Menu Katering:', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '• ${item.portionCount}x ${item.menu.name}\n  (${item.selectedOption})',
                            style: AppTypography.bodyRegular.copyWith(fontSize: 12),
                          ),
                        ),
                        Text(
                          state.formatCurrency(item.subtotal),
                          style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  )),
              const Divider(height: 24, color: AppColors.borderSubtle),
              _buildPriceLine('Total Tagihan', state.formatCurrency(order.total), isBold: true),
              _buildPriceLine('Status Uang Muka (DP)', order.isFullPayment ? 'Lunas 100%' : 'DP 50% (${state.formatCurrency(order.dpAmount)}) Terverifikasi', color: AppColors.success),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _contactAdminWhatsApp(order.id);
                },
                icon: const Icon(Icons.chat),
                label: const Text('Hubungi Admin Katering via WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.waGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceLine(String title, String val, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
        Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, fontSize: 13, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CateringState();

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final filteredOrders = state.orders.where((o) {
          if (_selectedFilterIndex == 1) {
            return o.status != OrderStatus.selesai && o.status != OrderStatus.dibatalkan;
          } else if (_selectedFilterIndex == 2) {
            return o.status == OrderStatus.selesai;
          }
          return true;
        }).toList();

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pesanan Katering', style: AppTypography.display1.copyWith(fontSize: 22)),
                        Text(
                          'Pantau status masak di dapur & jadwal kirim',
                          style: AppTypography.micro.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Status pesanan diperbarui dari server katering.')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Filter Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: _filters.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final title = entry.value;
                    final isSelected = _selectedFilterIndex == idx;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilterIndex = idx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                            ),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.textBody,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Orders List
              Expanded(
                child: filteredOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text('Belum ada pesanan pada filter ini', style: AppTypography.heading2),
                            const SizedBox(height: 4),
                            Text('Pesanan katering acaramu akan muncul disini.', style: AppTypography.micro),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                        itemCount: filteredOrders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return _buildOrderCard(context, order, state);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, CateringOrder order, CateringState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: AppTypography.micro.copyWith(fontWeight: FontWeight.w800, color: AppColors.textMuted),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    color: order.status.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Event Name
          Text(order.eventName, style: AppTypography.heading2.copyWith(fontSize: 16)),
          const SizedBox(height: 6),

          // Date & Time
          Row(
            children: [
              const Icon(Icons.event_note, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                '${order.eventDate} • Standby ${order.eventTime}',
                style: AppTypography.bodyRegular.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: AppTypography.micro.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 10),

          // Items summary
          Text(
            '${order.items.length} Menu • ${order.items.fold(0, (sum, i) => sum + i.portionCount)} Total Porsi',
            style: AppTypography.bodyRegular.copyWith(fontSize: 12, color: AppColors.textBody),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Biaya Katering:', style: AppTypography.micro),
              Text(
                state.formatCurrency(order.total),
                style: AppTypography.heading2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showOrderDetailSheet(context, order),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  child: const Text('Rincian Invoice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _contactAdminWhatsApp(order.id),
                  icon: const Icon(Icons.chat, size: 16),
                  label: const Text('Chat WA Admin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.waGreen,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
