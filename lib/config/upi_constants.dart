class UpiAppInfo {
  final String name;
  final String packageName;
  final String iconPath;
  final String appScheme;

  const UpiAppInfo({
    required this.name,
    required this.packageName,
    required this.iconPath,
    required this.appScheme,
  });
}

class UpiConstants {
  // Common 3rd party UPI applications on Android in India
  static const List<UpiAppInfo> popularUpiApps = [
    UpiAppInfo(
      name: 'Google Pay',
      packageName: 'com.google.android.apps.nbu.paisa.user',
      iconPath: 'assets/icons/gpay.png',
      appScheme: 'gpay',
    ),
    UpiAppInfo(
      name: 'PhonePe',
      packageName: 'com.phonepe.app',
      iconPath: 'assets/icons/phonepe.png',
      appScheme: 'phonepe',
    ),
    UpiAppInfo(
      name: 'Paytm',
      packageName: 'net.one97.paytm',
      iconPath: 'assets/icons/paytm.png',
      appScheme: 'paytmmp',
    ),
    UpiAppInfo(
      name: 'BHIM UPI',
      packageName: 'in.org.npci.upiapp',
      iconPath: 'assets/icons/bhim.png',
      appScheme: 'bhim',
    ),
    UpiAppInfo(
      name: 'CRED UPI',
      packageName: 'com.dreamplug.androidapp',
      iconPath: 'assets/icons/cred.png',
      appScheme: 'cred',
    ),
    UpiAppInfo(
      name: 'Amazon Pay',
      packageName: 'in.amazon.mShop.android.shopping',
      iconPath: 'assets/icons/amazonpay.png',
      appScheme: 'amazon',
    ),
  ];

  /// Builds a standard NPCI compliant UPI Deep Link URI string
  static Uri buildUpiUri({
    required String payeeVpa,
    required String payeeName,
    required String transactionId,
    required String transactionRefId,
    required String transactionNote,
    required double amount,
    String currency = 'INR',
    String? callbackUrl,
  }) {
    final queryParameters = <String, String>{
      'pa': payeeVpa,
      'pn': payeeName,
      'tr': transactionRefId,
      'tid': transactionId,
      'tn': transactionNote,
      'am': amount.toStringAsFixed(2),
      'cu': currency,
    };

    if (callbackUrl != null && callbackUrl.isNotEmpty) {
      queryParameters['url'] = callbackUrl;
    }

    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: queryParameters,
    );
  }
}
