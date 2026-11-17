import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/upi_constants.dart';

class UpiAppSelector extends StatelessWidget {
  final UpiAppInfo selectedApp;
  final Function(UpiAppInfo) onAppSelected;
  final TextEditingController? customVpaController;

  const UpiAppSelector({
    super.key,
    required this.selectedApp,
    required this.onAppSelected,
    this.customVpaController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose your UPI App',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Instant 100% secure payment through any installed UPI application',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 16),

        // Grid of popular Indian UPI Apps
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
          ),
          itemCount: UpiConstants.popularUpiApps.length,
          itemBuilder: (context, index) {
            final app = UpiConstants.popularUpiApps[index];
            final isSelected = selectedApp.packageName == app.packageName;

            return InkWell(
              onTap: () => onAppSelected(app),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryLight : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildUpiIcon(app.name),
                          const SizedBox(height: 8),
                          Text(
                            app.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppTheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Or enter custom VPA ID
        if (customVpaController != null) ...[
          const Row(
            children: [
              Expanded(child: Divider(color: AppTheme.border)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('OR USE UPI ID', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Divider(color: AppTheme.border)),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: customVpaController,
            decoration: InputDecoration(
              labelText: 'Enter UPI ID / VPA',
              hintText: 'e.g. yourname@okhdfcbank or 9876543210@paytm',
              prefixIcon: const Icon(Icons.alternate_email, color: AppTheme.primary),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: AppTheme.textSecondary),
                onPressed: () {},
                tooltip: 'Scan UPI QR',
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUpiIcon(String name) {
    Color iconColor;
    IconData iconData;

    switch (name) {
      case 'Google Pay':
        iconColor = const Color(0xFF4285F4);
        iconData = Icons.account_balance_wallet;
        break;
      case 'PhonePe':
        iconColor = const Color(0xFF5F259F);
        iconData = Icons.phone_android;
        break;
      case 'Paytm':
        iconColor = const Color(0xFF00B9F5);
        iconData = Icons.payments;
        break;
      case 'BHIM UPI':
        iconColor = const Color(0xFF00796B);
        iconData = Icons.security;
        break;
      case 'CRED UPI':
        iconColor = const Color(0xFF1E293B);
        iconData = Icons.credit_card;
        break;
      case 'Amazon Pay':
        iconColor = const Color(0xFFFF9900);
        iconData = Icons.shopping_bag;
        break;
      default:
        iconColor = AppTheme.primary;
        iconData = Icons.account_balance_wallet;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }
}
