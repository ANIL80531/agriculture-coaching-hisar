import '../config/app_constants.dart';

class PaymentTransaction {
  final String transactionId;
  final String orderId;
  final String courseId;
  final String courseTitle;
  final String userId;
  final double amount;
  final String currency;
  final String upiVpa;
  final String upiAppName;
  final String? upiAppPackage;
  final PaymentStatus status;
  final DateTime timestamp;
  final String? bankRefNumber;
  final String? failureReason;

  const PaymentTransaction({
    required this.transactionId,
    required this.orderId,
    required this.courseId,
    required this.courseTitle,
    required this.userId,
    required this.amount,
    this.currency = 'INR',
    required this.upiVpa,
    required this.upiAppName,
    this.upiAppPackage,
    required this.status,
    required this.timestamp,
    this.bankRefNumber,
    this.failureReason,
  });

  bool get isSuccessful => status == PaymentStatus.success;

  PaymentTransaction copyWith({
    String? transactionId,
    String? orderId,
    String? courseId,
    String? courseTitle,
    String? userId,
    double? amount,
    String? currency,
    String? upiVpa,
    String? upiAppName,
    String? upiAppPackage,
    PaymentStatus? status,
    DateTime? timestamp,
    String? bankRefNumber,
    String? failureReason,
  }) {
    return PaymentTransaction(
      transactionId: transactionId ?? this.transactionId,
      orderId: orderId ?? this.orderId,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      upiVpa: upiVpa ?? this.upiVpa,
      upiAppName: upiAppName ?? this.upiAppName,
      upiAppPackage: upiAppPackage ?? this.upiAppPackage,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      bankRefNumber: bankRefNumber ?? this.bankRefNumber,
      failureReason: failureReason ?? this.failureReason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'orderId': orderId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'upiVpa': upiVpa,
      'upiAppName': upiAppName,
      'upiAppPackage': upiAppPackage,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'bankRefNumber': bankRefNumber,
      'failureReason': failureReason,
    };
  }

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      transactionId: json['transactionId'] as String,
      orderId: json['orderId'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String? ?? '',
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      upiVpa: json['upiVpa'] as String,
      upiAppName: json['upiAppName'] as String,
      upiAppPackage: json['upiAppPackage'] as String?,
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      bankRefNumber: json['bankRefNumber'] as String?,
      failureReason: json['failureReason'] as String?,
    );
  }
}
