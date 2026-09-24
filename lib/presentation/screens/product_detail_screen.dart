import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String title;
  final String image;
  final String price;

  const ProductDetailScreen({
    Key? key,
    required this.title,
    required this.image,
    required this.price,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            widget.image,
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: MediaQuery.of(context).size.height * 0.45,
              color: AppColors.primarySoft,
            ),
          ),

          // Back Button & Heart
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircularButton(Icons.arrow_back, () => Navigator.pop(context)),
                  _buildCircularButton(Icons.favorite_border, () {}),
                ],
              ),
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.local_fire_department, color: AppColors.primary, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Sisa 3 Porsi Lagi!',
                                  style: AppTypography.micro.copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: AppTypography.display1.copyWith(fontSize: 24),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Text('4.9', style: AppTypography.heading2),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.price,
                            style: AppTypography.heading1.copyWith(color: AppColors.primary),
                          ),
                          const SizedBox(height: 24),
                          Text('Pilihan Porsi', style: AppTypography.heading2),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildPortionChip('Standard', true),
                              const SizedBox(width: 8),
                              _buildPortionChip('Jumbo', false),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text('Deskripsi', style: AppTypography.heading2),
                          const SizedBox(height: 8),
                          Text(
                            'Snack lezat dan gurih, sangat cocok untuk menemani rapat atau belajar kelompok. Dibuat dengan bahan premium dan higienis.',
                            style: AppTypography.bodyRegular,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Bottom Bar
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textTitle.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Quantity Stepper
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderSubtle),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (_quantity > 1) setState(() => _quantity--);
                                },
                              ),
                              Text('$_quantity', style: AppTypography.heading2),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => setState(() => _quantity++),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Add to Order Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CheckoutScreen(
                                    title: widget.title,
                                    price: widget.price,
                                    quantity: _quantity,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Add to Orders'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textTitle),
      ),
    );
  }

  Widget _buildPortionChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySoft : Colors.transparent,
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.bodyRegular.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textBody,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
