import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/state/catering_state.dart';
import 'wa_generator_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _eventNameController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  bool _isFullPayment = false; // False = DP 50%, True = Full 100%
  bool _needInvoiceLpj = true; // Request official LPJ receipt

  @override
  void initState() {
    super.initState();
    final state = CateringState();
    _eventNameController = TextEditingController(text: 'Seminar Nasional Kampus 2026');
    _nameController = TextEditingController(text: state.userName);
    _phoneController = TextEditingController(text: state.userPhone);
    _addressController = TextEditingController(text: state.selectedVenue);
    _notesController = TextEditingController(text: 'Mohon kurir hubungi PIC 30 menit sebelum tiba di gerbang kampus.');
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _processCheckout(CateringState state) {
    if (_formKey.currentState?.validate() ?? false) {
      final order = state.createOrder(
        eventName: _eventNameController.text,
        eventDate: state.eventDate,
        eventTime: state.eventTime,
        deliveryAddress: _addressController.text,
        contactName: _nameController.text,
        contactPhone: _phoneController.text,
        notes: _notesController.text + (_needInvoiceLpj ? ' [Perlu Invoice Kwitansi LPJ]' : ''),
        isFullPayment: _isFullPayment,
      );

      final waMessage = state.generateWhatsAppMessage(order);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WAGeneratorScreen(
            order: order,
            orderText: waMessage,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = CateringState();

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Checkout Pemesanan Katering'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Holding Timer & Slot Locked Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.urgencyAmberSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.urgencyAmber.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.urgencyAmber, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SLOT DAPUR TERKUNCI: 14:59',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.urgencyAmber,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Kapasitas masak untuk tanggal ${state.eventDate} diamankan.',
                            style: AppTypography.micro.copyWith(color: AppColors.textBody),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Event Schedule Card
              _buildSectionCard(
                title: 'Jadwal & Lokasi Acara',
                icon: Icons.event,
                children: [
                  TextFormField(
                    controller: _eventNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Acara / Kegiatan',
                      prefixIcon: Icon(Icons.celebration_outlined, color: AppColors.primary),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Nama acara wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tanggal Acara', style: AppTypography.micro),
                              const SizedBox(height: 2),
                              Text(state.eventDate, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jam Tiba Standby', style: AppTypography.micro),
                              const SizedBox(height: 2),
                              Text(state.eventTime, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Detail Gedung / Ruangan / Akses Masuk',
                      prefixIcon: Icon(Icons.location_city_outlined, color: AppColors.primary),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Alamat pengantaran wajib diisi' : null,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Contact PIC Card
              _buildSectionCard(
                title: 'Kontak PIC Penerima di Lokasi',
                icon: Icons.person_pin_circle_outlined,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap PIC Konsumsi',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Nama PIC wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'No. WhatsApp PIC (Aktif)',
                      prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Nomor WhatsApp wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Catatan Khusus untuk Kurir / Driver',
                      prefixIcon: Icon(Icons.notes_outlined, color: AppColors.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Payment Schema (DP vs Full Payment)
              _buildSectionCard(
                title: 'Skema Pembayaran Katering',
                icon: Icons.account_balance_wallet_outlined,
                children: [
                  _buildPaymentRadio(
                    title: 'Uang Muka (DP 50%) • Standar Katering',
                    subtitle: 'Bayar ${state.formatCurrency(state.dpAmount)} sekarang, sisa dilunasi H-1 sebelum acara.',
                    isSelected: !_isFullPayment,
                    onTap: () => setState(() => _isFullPayment = false),
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentRadio(
                    title: 'Pelunasan Penuh (100%)',
                    subtitle: 'Langsung beres tanpa tagihan tambahan menjelang hari H.',
                    isSelected: _isFullPayment,
                    onTap: () => setState(() => _isFullPayment = true),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _needInvoiceLpj,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (v) => setState(() => _needInvoiceLpj = v ?? true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sertakan Invoice Resmi & Kwitansi Bermaterai untuk LPJ / Reimbursement',
                          style: AppTypography.bodyRegular.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Rincian Pembayaran
              _buildSectionCard(
                title: 'Rincian Biaya Transparan',
                icon: Icons.receipt_long_outlined,
                children: [
                  _buildPriceRow('Subtotal Menu (${state.totalCartPortions} porsi)', state.formatCurrency(state.totalCartSubtotal)),
                  if (state.volumeDiscount > 0)
                    _buildPriceRow('Diskon Skala Akbar', '-${state.formatCurrency(state.volumeDiscount)}', color: AppColors.success),
                  _buildPriceRow('Ongkir Mobil Box Katering', state.estimatedDeliveryFee == 0 ? 'GRATIS' : state.formatCurrency(state.estimatedDeliveryFee), color: state.estimatedDeliveryFee == 0 ? AppColors.success : null),
                  _buildPriceRow('Biaya Penanganan & Kemasan', state.formatCurrency(state.serviceFee)),
                  const Divider(height: 24, color: AppColors.borderSubtle),
                  _buildPriceRow('Total Tagihan Acara', state.formatCurrency(state.grandTotal), isBold: true, fontSize: 16),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isFullPayment ? 'Total Dibayar Sekarang (100%):' : 'Nominal Uang Muka DP (50%):',
                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                        Text(
                          state.formatCurrency(_isFullPayment ? state.grandTotal : state.dpAmount),
                          style: AppTypography.heading2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _processCheckout(state),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle_outline, size: 20),
              SizedBox(width: 8),
              Text(
                'Konfirmasi & Buat Form WhatsApp',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.heading2),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPaymentRadio({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? AppColors.primaryDark : AppColors.textTitle,
                      fontSize: 13,
                    ),
                  ),
                  Text(subtitle, style: AppTypography.micro.copyWith(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? color, bool isBold = false, double fontSize = 13}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: AppColors.textBody,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
              color: color ?? AppColors.textTitle,
            ),
          ),
        ],
      ),
    );
  }
}
