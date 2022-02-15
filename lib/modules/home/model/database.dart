import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';
import 'package:squick/modules/wallet/model/credit_card.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider._();

  DatabaseProvider();

  static final DatabaseProvider db = DatabaseProvider._();
  List<CreditCard> _creditCards = [];
  bool isCreditCardValid = true;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "cards.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE CreditCard ("
              "cardNumber TEXT PRIMARY KEY"
              "expiryDate TEXT,"
              "cvv TEXT,"
              "cardHolder TEXT,"
              "isPrimary BIT,"
              "imageUrl TEXT"
              ")");
        });
  }

  bool get isValid {
    return isCreditCardValid;
  }

  int get count {
    return _creditCards.length;
  }

  List<CreditCard> get getLoadedCards {
    return _creditCards;
  }

  getAllCreditCards() async {
    final db = await database;
    var res = await db.query("CreditCard");

    List<CreditCard> list =
    res.isNotEmpty ? res.map((c) => CreditCard.fromMap(c)).toList() : [];

    _creditCards = list;

    await Future.delayed(const Duration(seconds: 1));

    return list;
  }

  int getLastCreditCardImageNumber() {
    if (_creditCards.isEmpty) return 0;
    var imgUrlParts = _creditCards[count - 1].imageUrl.split("_");
    return int.parse(imgUrlParts[2].split(".")[0]);
  }

  int getPrimaryCard() {
    for (var element in _creditCards) {
      if (element.isPrimary == 1) {
        return _creditCards.indexOf(element);
      }
    }
    return -1;
  }

  insertCreditCard(CreditCard card) async {
    if (_creditCards.isEmpty) card.isPrimary = 1;

    if (_creditCards.length == kMaxNumberOfCreditCards) return;

    if (checkForIdenticalCardNumberAndCvv(card.cardNumber, card.cvv)) {
      isCreditCardValid = false;
      return;
    }

    isCreditCardValid = true;

    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into CreditCard (cardNumber, expiryDate, cvv,cardHolder, isPrimary, imageUrl) VALUES (\"${card
            .cardNumber}\", \"${card.expiryDate}\", \"${card.cvv}\", \"${card
            .cardholderName}\", ${card.isPrimary}, \"${card.imageUrl}\")");

    _creditCards.add(card);
    notifyListeners();

    return await updateRemainingCards(card, res, db);
  }

  checkForIdenticalCardNumberAndCvv(String cardNumber, String cvv) {
    bool flag = false;

    _creditCards.forEach((element) {
      if (element.cardNumber == cardNumber && element.cvv == cvv) {
        flag = true;
      }
    });

    return flag;
  }

  updateCreditCard(CreditCard newCard) async {
    if (_creditCards.length == 1) newCard.isPrimary = 1;

    final db = await database;
    var res = await db.update("CreditCard", newCard.toMap(),
        where: "cardNumber = ?", whereArgs: [newCard.cardNumber]);

    return await updateRemainingCards(newCard, res, db);
  }

  updateRemainingCards(CreditCard newCard, var res, var db) async {
    if (newCard.isPrimary == 1) {
      _creditCards.forEach((element) async {
        if (element.cardNumber == newCard.cardNumber) {
          element.isPrimary = 1;
        } else if (element.isPrimary == 1 &&
            element.cardNumber != newCard.cardNumber) {
          element.isPrimary = 0;
          res = await db.update("CreditCard", element.toMap(),
              where: "cardNumber = ?", whereArgs: [element.cardNumber]);
        }
      });
    }

    notifyListeners();

    return res;
  }

  deleteCreditCard(String cardNumber) async {
    final db = await database;
    for (int i = 0; i < _creditCards.length; i++) {
      if (_creditCards[i].cardNumber == cardNumber &&
          _creditCards[i].isPrimary == 1) {
        return;
      }
    }
    db.delete("CreditCard", where: "cardNumber = ?", whereArgs: [cardNumber]);
    _creditCards.removeWhere((element) => element.cardNumber == cardNumber);
    notifyListeners();
  }
}
