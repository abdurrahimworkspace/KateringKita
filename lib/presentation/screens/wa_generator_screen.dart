import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/catering_models.dart';
import '../../core/state/catering_state.dart';
import 'home_screen.dart';

class WAGeneratorScreen extends StatefulWidget {
  final CateringOrder order;
  final String orderText;

  const WAGeneratorScreen({
    Key? key,
    required this.order,
    required this.orderText,
  }) : super(key: key);

  @override
  State<WAGeneratorScreen> createState() => _WAGeneratorScreenState();
}

class _WAGeneratorScreenState extends State<WAGeneratorScreen> {
  late String _currentText;

  @override
  void initState() {
    super.initState();
    _currentText = widget.orderText;
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    const adminPhone = '6281234567890';
    final encoded = Uri.encodeComponent(_currentText);
    final uri = Uri.parse('https://wa.me/$adminPhone?text=$encoded');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi WhatsApp secara otomatis.')),
        );
      }
    }
  }

  void _showEditDialog() {
    final controller = TextEditingController(text: _currentText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Pesan WhatsApp'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: controller,
            maxLines: 12,
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() => _currentText = controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CateringState();

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Order & Invoice Generator'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success Confirmation Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Formulir Pesanan Berhasil Dibuat!',
                          style: AppTypography.heading2.copyWith(color: const Color(0xFF065F46)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'No. PO: ${widget.order.id} • Kuota Masak Dapur Diamankan.',
                          style: AppTypography.micro.copyWith(color: AppColors.textBody),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Official Invoice Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INVOICE PESANAN KATERING',
                        style: AppTypography.micro.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.order.id,
                          style: AppTypography.micro.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildInvoiceRow('Acara:', widget.order.eventName),
                  _buildInvoiceRow('Jadwal:', '${widget.order.eventDate} • ${widget.order.eventTime}'),
                  _buildInvoiceRow('Lokasi:', widget.order.deliveryAddress),
                  _buildInvoiceRow('PIC Acara:', '${widget.order.contactName} (${widget.order.contactPhone})'),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildInvoiceRow('Total Tagihan:', state.formatCurrency(widget.order.total), isBold: true),
                  _buildInvoiceRow(
                    widget.order.isFullPayment ? 'Nominal Lunas:' : 'Uang Muka (DP 50%):',
                    state.formatCurrency(widget.order.dpAmount),
                    color: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // WhatsApp Message Preview Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Format Pesan WhatsApp Resmi:', style: AppTypography.heading2),
                TextButton.icon(
                  onPressed: _showEditDialog,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Format'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // WhatsApp Speech Bubble
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCF8C6), // Classic WA green bubble
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(color: const Color(0xFFB9E5A8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SelectableText(
                _currentText,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF1E293B),
                  height: 1.45,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _currentText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pesan PO Katering berhasil disalin!')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Salin Pesan'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Primary Launch WhatsApp Button
            ElevatedButton.icon(
              onPressed: () => _launchWhatsApp(context),
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              label: const Text(
                'Kirim Form ke WhatsApp Admin',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.waGreen,
                shadowColor: AppColors.waGreen.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: AppTypography.micro.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: color ?? AppColors.textTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
