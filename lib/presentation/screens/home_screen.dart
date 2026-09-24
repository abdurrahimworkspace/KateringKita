import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/food_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lokasi Pengiriman', style: AppTypography.micro),
                        Row(
                          children: [
                            Text('Kampus UI Depok', style: AppTypography.heading2),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('assets/images/avatar_user.jpg'),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.urgencyRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textTitle.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: AppColors.textMuted),
                      hintText: 'Cari snack rapat...',
                      hintStyle: AppTypography.bodyRegular.copyWith(color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    _buildCategoryChip('Semua', true),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Snack Gurih', false),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Manis', false),
                    const SizedBox(width: 8),
                    _buildCategoryChip('Paket Hemat', false),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/banner_sale.jpg',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: AppColors.primarySoft,
                      child: const Center(child: Text('Banner Promotion')),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Menu Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Rekomendasi Hari Ini', style: AppTypography.heading1),
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                  children: const [
                    FoodCard(
                      title: 'Lumpia Diego',
                      image: 'assets/images/lumpia.jpg',
                      price: 'Rp 15.000',
                      stock: 3,
                    ),
                    FoodCard(
                      title: 'Martabak Mini',
                      image: 'assets/images/martabak.jpg',
                      price: 'Rp 12.000',
                      stock: 8,
                    ),
                    FoodCard(
                      title: 'Nasi Kuning Bento',
                      image: 'assets/images/nasi_kuning.jpg',
                      price: 'Rp 22.000',
                      stock: 2,
                    ),
                    FoodCard(
                      title: 'Risoles Mayo',
                      image: 'assets/images/risoles.jpg',
                      price: 'Rp 10.000',
                      stock: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for floating dock
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.textTitle.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
              BottomNavigationBarItem(
                icon: CircleAvatar(
                  backgroundColor: AppColors.blueSoft,
                  child: Icon(Icons.auto_awesome, color: AppColors.blueTech),
                ),
                label: 'AI',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Liked'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderSubtle,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.bodyRegular.copyWith(
          color: isSelected ? Colors.white : AppColors.textBody,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}
