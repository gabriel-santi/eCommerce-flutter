import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastCartRepository implements LocalCartRepository {
  SembastCartRepository(this.db);

  final Database db;
  final store = StoreRef.main();

  static Future<Database> createDatabase(String filename) async {
    if (kIsWeb) {
      return databaseFactoryWeb.openDatabase(filename);
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      final path = join(appDocDir.path, filename);
      return databaseFactoryIo.openDatabase(path);
    }
  }

  static Future<SembastCartRepository> makeDefault() async {
    return SembastCartRepository(await createDatabase("default.db"));
  }

  static const cartItemsKey = "cartItems";

  @override
  Future<Cart> fetchCart() async {
    final cartJson = store.record(cartItemsKey).get(db) as String?;
    if (cartJson != null) {
      return Cart.fromJson(cartJson);
    } else {
      return Cart();
    }
  }

  @override
  Future<void> setCart(Cart cart) {
    return store.record(cartItemsKey).put(db, cart.toJson());
  }

  @override
  Stream<Cart> watchCart() {
    final record = store.record(cartItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Cart.fromJson(snapshot.value as String);
      } else {
        return Cart();
      }
    });
  }
}
