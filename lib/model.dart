import 'package:flutter/foundation.dart';
import 'package:nostr/nostr.dart';

class ProfileModel extends ChangeNotifier {
  Keychain keys = Keychain.generate();
}

class RelaysModel extends ChangeNotifier {
  final Set<String> _items = {};

  List<String> get items => _items.toList();

  void add(String url) {
    _items.add(url);
    notifyListeners();
  }

  void remove(String url) {
    _items.remove(url);
    notifyListeners();
  }
}
