import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/catering_models.dart';
import '../../core/state/catering_state.dart';
import '../widgets/food_card.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'ai_assistant_screen.dart';
import 'liked_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showVenuePicker(BuildContext context, CateringState state) {
    final venueController = TextEditingController(text: state.selectedVenue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Text(
              'Pilih Lokasi Pengiriman Acara',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              'Pastikan lokasi dapat diakses oleh mobil box / kurir katering.',
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: venueController,
              decoration: const InputDecoration(
                labelText: 'Gedung / Kampus / Alamat Acara',
                prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text('Rekomendasi Lokasi Kampus:', style: AppTypography.micro.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildLocationChip('Auditorium FT UI Depok', venueController),
                _buildLocationChip('Gedung Pusgiwa UI', venueController),
                _buildLocationChip('Balairung UI Depok', venueController),
                _buildLocationChip('Gedung BEM & Himpunan', venueController),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  state.selectedVenue = venueController.text;
                });
                Navigator.pop(ctx);
              },
              child: const Text('Simpan Lokasi Acara'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationChip(String text, TextEditingController controller) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: AppColors.surfaceSoft,
      side: const BorderSide(color: AppColors.borderSubtle),
      onPressed: () {
        controller.text = text;
      },
    );
  }

  void _showDatePickerModal(BuildContext context, CateringState state) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 2)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    ).then((selected) {
      if (selected != null) {
        setState(() {
          state.eventDate = '${selected.day} ${_getMonthName(selected.month)} ${selected.year}';
        });
      }
    });
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final state = CateringState();

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.bgMain,
          body: _buildCurrentTab(state),
          bottomNavigationBar: _buildBottomDock(),
        );
      },
    );
  }

  Widget _buildCurrentTab(CateringState state) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab(state);
      case 1:
        return const OrdersScreen();
      case 2:
        return AIAssistantScreen(
          onGoToHome: () => setState(() => _selectedIndex = 0),
        );
      case 3:
        return const LikedScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeTab(state);
    }
  }

  Widget _buildHomeTab(CateringState state) {
    final filteredMenus = state.menus.filter((m) {
      final matchesCategory = state.activeCategory == 'Semua' || m.category == state.activeCategory;
      final matchesQuery = state.searchQuery.isEmpty ||
          m.name.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
          m.description.toLowerCase().contains(state.searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 140), // Generous scroll padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Delivery Venue & Event Schedule Header
                _buildHeader(state),

                // 2. Search Bar & Filter Action
                _buildSearchBar(state),

                const SizedBox(height: 16),

                // 3. Catering Categories Chips
                _buildCategoryChips(state),

                const SizedBox(height: 16),

                // 4. Promotional Banners Carousel
                _buildPromoBanners(state),

                const SizedBox(height: 16),

                // 5. Trust Badges Bar (Halal, Higienis, Kurir Box)
                _buildTrustBadges(),

                const SizedBox(height: 20),

                // 6. Danus Profit Calculator Teaser Card
                _buildDanusTeaserCard(),

                const SizedBox(height: 24),

                // 7. Catalog Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Katalog Menu Katering', style: AppTypography.heading1),
                          Text(
                            'Harga grosir bertingkat • Porsi 10 s/d 2.000+',
                            style: AppTypography.micro.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${filteredMenus.length} Menu',
                          style: AppTypography.micro.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 8. Food Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    itemCount: filteredMenus.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.64,
                    ),
                    itemBuilder: (context, index) {
                      return FoodCard(menu: filteredMenus[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Cart Indicator if cart is not empty
        if (state.cart.isNotEmpty)
          Positioned(
            left: 20,
            right: 20,
            bottom: 96,
            child: _buildFloatingCartBar(state),
          ),
      ],
    );
  }

  Widget _buildHeader(CateringState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: AppColors.cardBg,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Venue Location Picker
              Expanded(
                child: GestureDetector(
                  onTap: () => _showVenuePicker(context, state),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lokasi Pengantaran Acara', style: AppTypography.micro),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    state.selectedVenue,
                                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w800),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Avatar
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 4),
                child: Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/avatar_user.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Event Schedule Badge
          GestureDetector(
            onTap: () => _showDatePickerModal(context, state),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Jadwal Acara: ${state.eventDate} • ${state.eventTime}',
                      style: AppTypography.bodyRegular.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textTitle,
                      ),
                    ),
                  ),
                  Text(
                    'Ubah',
                    style: AppTypography.micro.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
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

  Widget _buildSearchBar(CateringState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() => state.searchQuery = val);
                },
                decoration: InputDecoration(
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Icon(Icons.search, color: AppColors.textMuted, size: 22),
                  ),
                  hintText: 'Cari paket nasi bento, snack box, risoles...',
                  hintStyle: AppTypography.bodyRegular.copyWith(color: AppColors.textMuted, fontSize: 13),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => state.searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter berdasarkan budget dan tipe acara aktif.')),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(CateringState state) {
    final categories = [
      'Semua',
      'Nasi Kotak & Bento',
      'Paket Danus Mahasiswa',
      'Snack Box Rapat',
      'Prasmanan & Buffet',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: categories.map((cat) {
          final isSelected = state.activeCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => state.activeCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  cat,
                  style: AppTypography.bodyRegular.copyWith(
                    color: isSelected ? Colors.white : AppColors.textBody,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromoBanners(CateringState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 145,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFE64A19), Color(0xFFFF7043)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.18,
                child: Image.asset('assets/images/banner_sale.jpg', width: 220, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'PROMO PESANAN AKBAR',
                      style: AppTypography.micro.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Diskon Grosir s/d 17%\n+ Gratis Ongkir Mobil Box',
                    style: AppTypography.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 17,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Khusus pesanan di atas 100 porsi • Berlaku Harian',
                    style: AppTypography.micro.copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTrustItem(Icons.verified, '100% Halal MUI', AppColors.success),
            _buildTrustItem(Icons.access_time_filled, 'Tepat Waktu', AppColors.primary),
            _buildTrustItem(Icons.local_shipping, 'Mobil Box Katering', AppColors.blueTech),
            _buildTrustItem(Icons.receipt_long, 'Invoice LPJ', AppColors.urgencyAmber),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.micro.copyWith(fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildDanusTeaserCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = 2), // switch to AI Planner
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blueSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.blueTech.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.blueTech,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Catering & Danus Budget Planner',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.blueTech,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Punya dana terbatas? Biarkan AI atur paket konsumsi optimal sesuai budget!',
                      style: AppTypography.micro.copyWith(color: AppColors.textBody),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.blueTech),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCartBar(CateringState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.textTitle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${state.cart.length} Menu • ${state.totalCartPortions} Porsi',
                  style: AppTypography.bodyRegular.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  state.formatCurrency(state.grandTotal),
                  style: AppTypography.micro.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedCornerShape(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Checkout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDock() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDockItem(0, Icons.home_rounded, Icons.home_outlined, 'Beranda'),
              _buildDockItem(1, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Pesanan'),
              _buildAIDockItem(),
              _buildDockItem(3, Icons.favorite_rounded, Icons.favorite_border_rounded, 'Favorit'),
              _buildDockItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDockItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIDockItem() {
    final isSelected = _selectedIndex == 2;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blueTech : AppColors.blueSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: isSelected ? Colors.white : AppColors.blueTech,
              size: 20,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Danus AI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isSelected ? AppColors.blueTech : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
extension IterableExtension<T> on Iterable<T> {
  Iterable<T> filter(bool Function(T) test) sync* {
    for (var element in this) {
      if (test(element)) yield element;
    }
  }
}
