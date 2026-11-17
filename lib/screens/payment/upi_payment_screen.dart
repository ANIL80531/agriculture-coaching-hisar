import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/payment_provider.dart';
import '../../widgets/upi_app_selector.dart';
import 'payment_receipt_screen.dart';

class UpiPaymentScreen extends StatefulWidget {
  final CourseModel course;

  const UpiPaymentScreen({super.key, required this.course});

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  final TextEditingController _customVpaController = TextEditingController();

  @override
  void dispose() {
    _customVpaController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await paymentProvider.processCoursePayment(
      course: widget.course,
      authProvider: authProvider,
      customUpiId: _customVpaController.text.trim().isNotEmpty
          ? _customVpaController.text.trim()
          : null,
    );

    if (!mounted) return;

    if (success && paymentProvider.latestTransaction != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentReceiptScreen(
            transaction: paymentProvider.latestTransaction!,
            course: widget.course,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(paymentProvider.errorMessage ?? 'Payment could not be processed.'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: AppConstants.currencySymbol,
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('UPI Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.course.thumbnailUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 56,
                            height: 56,
                            color: AppTheme.primaryLight,
                            child: const Icon(Icons.school, color: AppTheme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.course.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Instructor: ${widget.course.instructorName}',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: AppTheme.border, height: 1),
                  const SizedBox(height: 12),

                  // Price Breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Original Price', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                      Text(currencyFormatter.format(widget.course.originalPrice), style: const TextStyle(fontSize: 13, decoration: TextDecoration.lineThrough, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Promotional Discount', style: TextStyle(fontSize: 13, color: AppTheme.success)),
                      Text('- ${currencyFormatter.format(widget.course.originalPrice - widget.course.price)}', style: const TextStyle(fontSize: 13, color: AppTheme.success, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Platform / Gateway Fee', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                      Text('FREE (₹0)', style: TextStyle(fontSize: 13, color: AppTheme.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppTheme.border, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      Text(currencyFormatter.format(widget.course.price), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // UPI Payment Method Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: UpiAppSelector(
                selectedApp: paymentProvider.selectedUpiApp,
                onAppSelected: (app) => paymentProvider.selectUpiApp(app),
                customVpaController: _customVpaController,
              ),
            ),
            const SizedBox(height: 20),

            // Payee Security Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, color: AppTheme.primary, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'NPCI 256-bit Encrypted. Payment will be credited directly to educator\'s verified UPI VPA.',
                      style: TextStyle(fontSize: 11, color: AppTheme.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: paymentProvider.isProcessing ? null : _handlePayment,
                icon: paymentProvider.isProcessing
                    ? const SizedBox.shrink()
                    : const Icon(Icons.lock, size: 18),
                label: paymentProvider.isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Opening UPI App...'),
                        ],
                      )
                    : Text(
                        'Pay ${currencyFormatter.format(widget.course.price)} via ${paymentProvider.selectedUpiApp.name}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
