import 'dart:async';

import 'package:flutter/foundation.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
