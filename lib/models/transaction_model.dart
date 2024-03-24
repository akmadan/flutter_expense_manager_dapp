class TransactionModel {
  final String address;
  final int amount;
  final String reason;
  final DateTime timestamp;

  TransactionModel(this.address, this.amount, this.reason, this.timestamp);
}
