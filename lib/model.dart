import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nostr/nostr.dart';

class ProfileModel extends ChangeNotifier {
  Keychain keys = Keychain.generate();
}

class RelaysModel extends ChangeNotifier {
  RelaysModel(this._items);

  final Set<String> _items;
  
  List<String> get items => _items.toList();

  void add(String url) {
    _items.add(url);
    _sync();
  }

  void remove(String url) {
    _items.remove(url);
    _sync();
  }

  void _sync() {
    GetStorage().write('relays', _items.toList());
    notifyListeners();
  }
}
