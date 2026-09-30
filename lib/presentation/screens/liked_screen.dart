import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/state/catering_state.dart';
import '../widgets/food_card.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = CateringState();

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final favoriteMenus = state.menus.where((m) => state.isFavorite(m.id)).toList();

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Menu Katering Favorit', style: AppTypography.display1.copyWith(fontSize: 22)),
                    Text(
                      'Daftar menu tersimpan untuk acara mendatang',
                      style: AppTypography.micro.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: favoriteMenus.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text('Belum ada menu yang difavoritkan', style: AppTypography.heading2),
                            const SizedBox(height: 4),
                            Text('Simpan menu katering favoritmu dengan menekan ikon hati.', style: AppTypography.micro),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                        itemCount: favoriteMenus.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.64,
                        ),
                        itemBuilder: (context, index) {
                          return FoodCard(menu: favoriteMenus[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
