import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static Db? db;
  static DbCollection? usersCollection;

  static Future<void> connect() async {
    db = await Db.create("mongodb+srv://rahulchauhxn:narangwal@cluster0.r52nk.mongodb.net/");
    await db!.open();
    usersCollection = db!.collection("users");
  }
}
