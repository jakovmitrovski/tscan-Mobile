class TransactionDto {
  String userId;
  int ticketId;
  int price;
  String paymentStatus;

  TransactionDto(this.userId, this.ticketId, this.price, this.paymentStatus);

  toJSON() {
    return <String, dynamic> {
      'userId': userId,
      'ticketId': ticketId,
      'price': price,
      'paymentStatus': paymentStatus,
    };
  }
}
