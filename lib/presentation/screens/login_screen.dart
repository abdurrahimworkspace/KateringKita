import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/state/catering_state.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;
  String _userRole = 'danus'; // 'danus' or 'corporate'

  // Text controllers
  final _emailController = TextEditingController(text: 'ahmad.pratama@student.ui.ac.id');
  final _passwordController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController(text: 'Ahmad Pratama');
  final _phoneController = TextEditingController(text: '081234567890');
  final _orgController = TextEditingController(text: 'BEM Universitas Indonesia');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _orgController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() => _isLoading = true);
    final state = CateringState();
    state.userName = _nameController.text.isNotEmpty ? _nameController.text : 'Ahmad Pratama';
    state.userEmail = _emailController.text;
    state.userPhone = _phoneController.text.isNotEmpty ? _phoneController.text : '081234567890';
    state.userOrganization = _orgController.text.isNotEmpty ? _orgController.text : 'Panitia Acara Kampus';
    state.isLoggedIn = true;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // App Brand Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KATERINGKITA',
                        style: AppTypography.heading1.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Solusi Konsumsi & Danusan Acara',
                        style: AppTypography.micro.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Hero Greeting
              Text(
                'Pesan Katering Tanpa Cemas,\nTepat Waktu & Bergaransi.',
                style: AppTypography.display1.copyWith(fontSize: 22, height: 1.3),
              ),
              const SizedBox(height: 6),
              Text(
                'Akses menu grosir khusus acara mahasiswa, seminar, hingga ribuan porsi.',
                style: AppTypography.bodyRegular.copyWith(color: AppColors.textBody, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Segmented Tab for Login & Register
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.w700),
                  unselectedLabelStyle: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.w500),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Masuk Akun'),
                    Tab(text: 'Daftar Baru'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Role Selector Chip
              Text(
                'Kategori Pemesan:',
                style: AppTypography.micro.copyWith(fontWeight: FontWeight.w700, color: AppColors.textTitle),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleSelector(
                      title: 'Panitia Kampus / Danus',
                      subtitle: 'Mahasiswa, BEM & UKM',
                      icon: Icons.school_outlined,
                      isSelected: _userRole == 'danus',
                      onTap: () => setState(() => _userRole = 'danus'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRoleSelector(
                      title: 'Kantor / Umum / EO',
                      subtitle: 'Seminar & Resepsi',
                      icon: Icons.business_outlined,
                      isSelected: _userRole == 'corporate',
                      onTap: () => setState(() => _userRole = 'corporate'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tab Views
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  return _tabController.index == 0
                      ? _buildLoginForm()
                      : _buildRegisterForm();
                },
              ),

              const SizedBox(height: 16),

              // Or divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('atau masuk dengan', style: AppTypography.micro),
                  ),
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                ],
              ),
              const SizedBox(height: 16),

              // Google Auth Button
              OutlinedButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: Color(0xFFEA4335)),
                label: Text(
                  'Lanjutkan dengan Akun Google',
                  style: AppTypography.bodyRegular.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTitle,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderSubtle),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),

              const SizedBox(height: 24),
              // Trust Footer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.successSoft.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user, color: AppColors.success, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Jaminan Invoice Resmi, Kwitansi Bermaterai untuk LPJ, & Halal MUI 100%.',
                        style: AppTypography.micro.copyWith(color: Color(0xFF065F46)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textTitle,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.micro.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Email Terdaftar / Email Kampus', style: AppTypography.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'nama@student.kampus.ac.id / kantor.com',
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted, size: 20),
          ),
        ),
        const SizedBox(height: 16),
        Text('Password', style: AppTypography.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primary,
                    shape: RoundedCornerShape(4),
                    onChanged: (val) => setState(() => _rememberMe = val ?? true),
                  ),
                ),
                const SizedBox(width: 6),
                Text('Ingat Saya', style: AppTypography.bodyRegular.copyWith(fontSize: 13)),
              ],
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tautan reset password dikirimkan ke email terdaftar.')),
                );
              },
              child: Text(
                'Lupa Password?',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Masuk ke KateringKita'),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Nama Lengkap Penanggung Jawab (PIC)', style: AppTypography.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Contoh: Ahmad Pratama',
            prefixIcon: Icon(Icons.person_outline, color: AppColors.textMuted, size: 20),
          ),
        ),
        const SizedBox(height: 14),
        Text('Nama Organisasi / Lembaga / Acara', style: AppTypography.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          controller: _orgController,
          decoration: const InputDecoration(
            hintText: 'Contoh: BEM Fakultas Teknik UI / PT Sinar Solusi',
            prefixIcon: Icon(Icons.apartment_outlined, color: AppColors.textMuted, size: 20),
          ),
        ),
        const SizedBox(height: 14),
        Text('No. WhatsApp Aktif (Untuk Koordinasi Kurir)', style: AppTypography.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '0812xxxxxxxx',
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textMuted, size: 20),
          ),
        ),
        const SizedBox(height: 14),
        Text('Email Akun', style: AppTypography.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'email@instansi.com',
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted, size: 20),
          ),
        ),
        const SizedBox(height: 14),
        Text('Buat Password Baru', style: AppTypography.bodyMedium),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Minimal 8 karakter',
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Daftar Akun Katering'),
        ),
      ],
    );
  }
}
