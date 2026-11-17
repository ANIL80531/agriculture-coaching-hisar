import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../models/course_model.dart';
import '../../models/payment_model.dart';
import '../course/course_content_viewer_screen.dart';
import '../student/student_main_navigation.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final PaymentTransaction transaction;
  final CourseModel course;

  const PaymentReceiptScreen({
    super.key,
    required this.transaction,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: AppConstants.currencySymbol,
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Success Icon Animation
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.success,
                  size: 54,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your course has been unlocked. All live lectures and PPTs are now accessible.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // Digital Receipt Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildReceiptRow('Amount Paid', currencyFormatter.format(transaction.amount), isBold: true),
                    const Divider(height: 20, color: AppTheme.border),
                    _buildReceiptRow('Course', course.title),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Transaction ID', transaction.transactionId),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Order Reference', transaction.orderId),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Bank Ref / UTR', transaction.bankRefNumber ?? 'UPI-UTR-984128'),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Payment App', transaction.upiAppName),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Date & Time', dateFormatter.format(transaction.timestamp)),
                    const SizedBox(height: 10),
                    _buildReceiptRow('Status', 'COMPLETED (SUCCESS)', statusColor: AppTheme.success),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseContentViewerScreen(course: course),
                      ),
                    );
                  },
                  icon: const Icon(Icons.school),
                  label: const Text('Start Course Content Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentMainNavigation(initialIndex: 1),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Go to My Courses'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, Color? statusColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isBold ? 15 : 12,
              fontWeight: isBold || statusColor != null ? FontWeight.bold : FontWeight.w500,
              color: statusColor ?? (isBold ? AppTheme.primary : AppTheme.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
