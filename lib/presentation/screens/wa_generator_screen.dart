import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WAGeneratorScreen extends StatelessWidget {
  final String orderText;

  const WAGeneratorScreen({Key? key, required this.orderText}) : super(key: key);

  Future<void> _launchWA(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/6281234567890?text=${Uri.encodeComponent(orderText)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Generator'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.waGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.waGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pesanan Berhasil Disiapkan!',
                        style: AppTypography.heading2.copyWith(color: AppColors.waGreen),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Preview Pesan WhatsApp:',
                style: AppTypography.heading2,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCF8C6), // WA Bubble color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  orderText,
                  style: AppTypography.bodyRegular.copyWith(color: Colors.black87),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Salin Pesan', style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Edit Pesan', style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _launchWA(context),
                icon: const Icon(Icons.chat),
                label: const Text('Buka WhatsApp Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.waGreen,
                  shadowColor: AppColors.waGreen.withOpacity(0.28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
