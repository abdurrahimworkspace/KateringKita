import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/state/catering_state.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _showLogoutDialog(BuildContext context, CateringState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Akun?'),
        content: const Text('Kamu akan keluar dari akun KateringKita. Pesanan aktif tetap akan diproses oleh tim dapur katering.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              state.isLoggedIn = false;
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.urgencyRed),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(message, style: const TextStyle(fontSize: 13, height: 1.4)),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CateringState();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profil & Akun Lembaga', style: AppTypography.display1.copyWith(fontSize: 22)),
            Text(
              'Pengaturan akun katering, alamat acara & berkas LPJ',
              style: AppTypography.micro.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 20),

            // Profile Card
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
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/avatar_user.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    state.userName,
                                    style: AppTypography.heading2.copyWith(fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'VIP Danus',
                                    style: AppTypography.micro.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.userEmail,
                              style: AppTypography.micro.copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.userOrganization,
                              style: AppTypography.micro.copyWith(color: AppColors.textBody, fontSize: 11, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('Pesanan Selesai', '${state.orders.length} Acara'),
                      Container(width: 1, height: 30, color: AppColors.borderSubtle),
                      _buildProfileStat('Saldo Cashback', 'Rp 350.000'),
                      Container(width: 1, height: 30, color: AppColors.borderSubtle),
                      _buildProfileStat('Porsi Terkirim', '320+ Box'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 1: Berkas & Manajemen Katering
            Text('Manajemen Katering Acara', style: AppTypography.heading2.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            _buildSettingsGroup([
              _buildSettingTile(
                icon: Icons.location_on_outlined,
                title: 'Daftar Lokasi Pengantaran Acara',
                subtitle: state.selectedVenue,
                onTap: () {
                  _showInfoDialog(context, 'Alamat Tersimpan', 'Lokasi utama saat ini: ${state.selectedVenue}.\nKamu dapat mengubahnya di halaman Beranda.');
                },
              ),
              _buildSettingTile(
                icon: Icons.receipt_long_outlined,
                title: 'Faktur & Kwitansi Resmi LPJ',
                subtitle: 'Unduh rekap bukti bayar bermaterai untuk laporan keuangan',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rekap kuitansi LPJ siap diekspor ke format PDF.')),
                  );
                },
              ),
              _buildSettingTile(
                icon: Icons.business_outlined,
                title: 'Data Instansi / NPWP Perusahaan',
                subtitle: 'Untuk faktur pajak dan penerbitan PO B2B',
                onTap: () {
                  _showInfoDialog(context, 'Data Penagihan', 'Terdaftar atas nama: ${state.userOrganization}.\nFaktur pajak dapat diterbitkan atas permintaan H-3.');
                },
              ),
            ]),

            const SizedBox(height: 20),

            // Section 2: Jaminan & Bantuan Vendor
            Text('Jaminan Layanan & Customer Service', style: AppTypography.heading2.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            _buildSettingsGroup([
              _buildSettingTile(
                icon: Icons.support_agent_outlined,
                title: 'Hubungi Account Manager Katering',
                subtitle: 'Hotline WhatsApp khusus konsultasi menu & kapasitas dapur',
                iconColor: AppColors.waGreen,
                onTap: () async {
                  final uri = Uri.parse('https://wa.me/6281234567890?text=Halo%20Account%20Manager%20KateringKita,%20saya%20ingin%20konsultasi%20menu%20acara.');
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (_) {}
                },
              ),
              _buildSettingTile(
                icon: Icons.verified_outlined,
                title: 'Garansi Tepat Waktu 100%',
                subtitle: 'Kompensasi 50% jika pengantaran terlambat lebih dari 15 menit',
                iconColor: AppColors.primary,
                onTap: () {
                  _showInfoDialog(
                    context,
                    'Garansi Tepat Waktu',
                    'KateringKita berkomitmen tepat waktu. Driver mobil box kami tiba di lokasi 30-45 menit sebelum jam acara dimulai. Jika terlambat lebih dari 15 menit tanpa konfirmasi darurat, kami memberikan diskon kompensasi 50%.',
                  );
                },
              ),
              _buildSettingTile(
                icon: Icons.policy_outlined,
                title: 'Syarat Pembatalan & Perubahan Porsi',
                subtitle: 'Perubahan jumlah porsi dapat dilakukan maksimal H-2 acara',
                onTap: () {
                  _showInfoDialog(
                    context,
                    'Ketentuan Pembatalan & Revisi',
                    '1. Penambahan porsi dapat diajukan s/d H-1 pukul 12.00 WIB.\n2. Pengurangan porsi maksimal H-2 sebelum belanja bahan dapur.\n3. Uang muka (DP) dapat dialihkan ke tanggal lain jika acara diundur.',
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Logout Button
            OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context, state),
              icon: const Icon(Icons.logout, color: AppColors.urgencyRed),
              label: const Text('Keluar dari Akun', style: TextStyle(color: AppColors.urgencyRed, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.urgencyRed),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.heading2.copyWith(fontSize: 14, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.micro.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTypography.bodyMedium.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: AppTypography.micro.copyWith(fontSize: 11)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.textMuted),
    );
  }
}
