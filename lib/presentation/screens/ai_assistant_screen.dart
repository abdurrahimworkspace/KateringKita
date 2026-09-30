import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/state/catering_state.dart';
import 'cart_screen.dart';

class AIAssistantScreen extends StatefulWidget {
  final VoidCallback? onGoToHome;

  const AIAssistantScreen({Key? key, this.onGoToHome}) : super(key: key);

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final _headcountController = TextEditingController(text: '80');
  final _budgetController = TextEditingController(text: '2000000');
  String _eventType = 'Danusan Kampus (Cari Dana)';

  final List<String> _eventTypes = [
    'Danusan Kampus (Cari Dana)',
    'Seminar & Workshop Kampus',
    'Rapat Pleno Organisasi / BEM',
    'Syukuran / Dies Natalis Akbar',
  ];

  @override
  void dispose() {
    _headcountController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = CateringState();
    final headcount = int.tryParse(_headcountController.text) ?? 80;
    final totalBudget = int.tryParse(_budgetController.text) ?? 2000000;
    final budgetPerPerson = headcount > 0 ? (totalBudget / headcount).toInt() : 0;

    // AI Calculations
    final isDanus = _eventType.contains('Danusan');
    final estimatedDanusProfit = isDanus ? (headcount * 6000) : 0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blueSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.blueTech, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Danus & Catering AI Planner', style: AppTypography.heading1),
                      Text(
                        'Kalkulator Konsumsi & Laba Acara Otomatis',
                        style: AppTypography.micro.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Form Parameters Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Jenis Acara / Tujuan Pesanan:', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _eventType,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                        items: _eventTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type, style: AppTypography.bodyRegular.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _eventType = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text('2. Jumlah Peserta / Porsi Target:', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _headcountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: 80',
                      prefixIcon: Icon(Icons.people_outline, color: AppColors.primary),
                      suffixText: 'Orang / Porsi',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 18),

                  Text('3. Total Anggaran / Modal Acara (Rp):', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: 2000000',
                      prefixIcon: Icon(Icons.payments_outlined, color: AppColors.primary),
                      prefixText: 'Rp ',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Alokasi per Peserta:', style: AppTypography.micro.copyWith(fontWeight: FontWeight.bold)),
                        Text(
                          '${state.formatCurrency(budgetPerPerson)} / orang',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // AI Recommendation Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.blueSoft.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.blueTech.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.smart_toy_outlined, color: AppColors.blueTech, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Rekomendasi Paket AI Paling Efisien',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.blueTech,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (isDanus) ...[
                    // Danus Profit Breakdown
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.success.withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.trending_up, color: AppColors.success, size: 20),
                              SizedBox(width: 8),
                              Text('Proyeksi Keuntungan Danus Kampus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF065F46))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('• Harga Beli Modal Katering: Rp 9.000 / porsi (Grosir $headcount pcs)', style: const TextStyle(fontSize: 12)),
                          Text('• Rekomendasi Jual ke Mahasiswa: Rp 15.000 / porsi', style: const TextStyle(fontSize: 12)),
                          Text('• Margin Bersih: Rp 6.000 per porsi', style: const TextStyle(fontSize: 12)),
                          const Divider(height: 14, color: AppColors.borderSubtle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Estimasi Kas Danus Masuk:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                state.formatCurrency(estimatedDanusProfit),
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.success),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Text(
                    'Paket Kombinasi $headcount Porsi Disarankan:',
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildPackageItem(
                    title: isDanus ? 'Paket Danus Risoles Mayo Lumer' : 'Nasi Kotak Bento Ayam Bakar Madu',
                    qty: headcount,
                    price: isDanus ? 9000 : 22500,
                    state: state,
                  ),
                  const SizedBox(height: 6),
                  _buildPackageItem(
                    title: 'Snack Box Pendamping / Air Mineral Cup',
                    qty: headcount,
                    price: 2500,
                    state: state,
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton.icon(
                    onPressed: () {
                      final menuToOrder = isDanus ? state.menus[1] : state.menus[0];
                      state.addToCart(
                        menu: menuToOrder,
                        selectedOption: menuToOrder.packageOptions.first,
                        portionCount: headcount,
                        notes: 'Rekomendasi Paket Danus AI Optimizer ($headcount porsi)',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Paket AI ($headcount porsi) dimasukkan ke Keranjang!'),
                          action: SnackBarAction(
                            label: 'Ke Keranjang',
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const CartScreen()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text('Terapkan & Pesan Paket ($headcount Porsi)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageItem({required String title, required int qty, required int price, required CateringState state}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$qty porsi • $title',
              style: AppTypography.bodyRegular.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            state.formatCurrency(qty * price),
            style: AppTypography.bodyRegular.copyWith(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
