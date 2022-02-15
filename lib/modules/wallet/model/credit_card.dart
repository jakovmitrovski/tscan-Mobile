import 'dart:convert';

CreditCard cardFromJson(String str) {
  final jsonData = json.decode(str);
  return CreditCard.fromMap(jsonData);
}

String clientToJson(CreditCard data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class CreditCard {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;

  final String imageUrl;
  int isPrimary = 0;

  CreditCard(this.imageUrl,
      {required this.cardNumber,
      required this.expiryDate,
      required this.cvv,
      required this.cardholderName,
      required this.isPrimary});

  factory CreditCard.fromMap(Map<String, dynamic> json) => CreditCard(
        json["imageUrl"],
        cardNumber: json["cardNumber"],
        expiryDate: json["expiryDate"],
        cvv: json["cvv"],
        cardholderName: json["cardHolder"],
        isPrimary: json["isPrimary"],
      );

  Map<String, dynamic> toMap() => {
        "cardNumber": cardNumber,
        "expiryDate": expiryDate,
        "cvv": cvv,
        "cardHolder": cardholderName,
        "isPrimary": isPrimary,
        "imageUrl": imageUrl
      };
}
