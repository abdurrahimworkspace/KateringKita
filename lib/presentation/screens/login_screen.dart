import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Text(
                'Selamat Datang\ndi Kuliner Danus!',
                style: AppTypography.display1,
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk untuk melanjutkan pesanan',
                style: AppTypography.bodyRegular,
              ),
              const SizedBox(height: 48),
              Text(
                'Email Kampus',
                style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'nama@student.kampus.ac.id',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.cardBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Password',
                style: AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.cardBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Lupa Password?',
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text('Masuk'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun? ',
                    style: AppTypography.bodyRegular,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Register
                    },
                    child: Text(
                      'Daftar Sekarang',
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
