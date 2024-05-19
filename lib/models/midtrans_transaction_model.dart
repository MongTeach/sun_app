import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

class MidtransTransaction {
  final String id;
  final String vaNumber;
  final String bank;
  final String transactionType;
  final String referenceId;
  final String issuer;
  final String transactionTime;
  final String transactionStatus;
  final String transactionId;
  final String statusMessage;
  final String statusCode;
  final String signatureKey;
  final String settlementTime;
  final String paymentType;
  final String orderId;
  final String merchantId;
  final double grossAmount;
  final String fraudStatus;
  final String expiryTime;
  final String currency;
  final String acquirer;
  final String email;
  final String productId;
  final String postId;

  MidtransTransaction({
    required this.id,
    required this.vaNumber,
    required this.bank,
    required this.transactionType,
    required this.referenceId,
    required this.issuer,
    required this.transactionTime,
    required this.transactionStatus,
    required this.transactionId,
    required this.statusMessage,
    required this.statusCode,
    required this.signatureKey,
    required this.settlementTime,
    required this.paymentType,
    required this.orderId,
    required this.merchantId,
    required this.grossAmount,
    required this.fraudStatus,
    required this.expiryTime,
    required this.currency,
    required this.acquirer,
    required this.email,
    required this.productId,
    required this.postId,
  });

  factory MidtransTransaction.fromJson(Map<String, dynamic> json) {
    return MidtransTransaction(
      id: json['id'].toString(),
      vaNumber: json['va_number'],
      bank: json['bank'],
      transactionType: json['transaction_type'],
      referenceId: json['reference_id'],
      issuer: json['issuer'],
      transactionTime: json['transaction_time'],
      transactionStatus: json['transaction_status'],
      transactionId: json['transaction_id'],
      statusMessage: json['status_message'],
      statusCode: json['status_code'],
      signatureKey: json['signature_key'],
      settlementTime: json['settlement_time'],
      paymentType: json['payment_type'],
      orderId: json['order_id'],
      merchantId: json['merchant_id'],
      grossAmount: parseDouble(json['gross_amount']),
      fraudStatus: json['fraud_status'],
      expiryTime: json['expiry_time'],
      currency: json['currency'],
      acquirer: json['acquirer'],
      email: json['email'],
      productId: json['product_id'],
      postId: json['post_id'],
    );
  }

  static double parseDouble(String value) {
    try {
      return Decimal.parse(value).toDouble();
    } catch (e) {
      if (kDebugMode) {
        print('Terjadi kesalahan saat mengonversi nilai desimal: $e');
      }
      return 0.0; // Nilai default jika terjadi kesalahan
    }
  }
}
