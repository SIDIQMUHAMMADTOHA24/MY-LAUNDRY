import 'package:d_method/d_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginStatusProviders = StateProvider.autoDispose((ref) => '');

setLoginStatus(WidgetRef ref, String newStatus) {
  DMethod.printTitle('setLoginStatus', newStatus);
  ref.read(loginStatusProviders.notifier).state = newStatus;
}
