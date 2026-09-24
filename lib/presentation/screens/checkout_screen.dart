import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'wa_generator_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final String title;
  final String price;
  final int quantity;

  const CheckoutScreen({
    Key? key,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming price format like "Rp 15.000"
    final priceValue = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final subtotal = priceValue * quantity;
    final fee = 2000;
    final total = subtotal + fee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Holding Timer Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: AppColors.urgencyAmber),
                    const SizedBox(width: 8),
                    Text(
                      'KUOTA TERKUNCI 04:59',
                      style: AppTypography.heading2.copyWith(color: AppColors.urgencyAmber),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Order Summary
              Text('Ringkasan Pesanan', style: AppTypography.heading2),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTypography.heading2),
                          const SizedBox(height: 4),
                          Text(price, style: AppTypography.bodyRegular),
                        ],
                      ),
                    ),
                    Text('x$quantity', style: AppTypography.heading2),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form
              Text('Detail Pemesan', style: AppTypography.heading2),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'No WhatsApp',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Payment Breakdown
              Text('Rincian Pembayaran', style: AppTypography.heading2),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: AppTypography.bodyRegular),
                  Text('Rp $subtotal', style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Biaya Layanan', style: AppTypography.bodyRegular),
                  Text('Rp $fee', style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 32, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: AppTypography.heading2),
                  Text(
                    'Rp $total',
                    style: AppTypography.heading1.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WAGeneratorScreen(
                          orderText: 'Halo Danus, saya mau pesan $title sejumlah $quantity porsi. Total: Rp $total.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Konfirmasi Pesanan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
