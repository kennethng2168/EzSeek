import 'package:riverpod/riverpod.dart';

// Define a StateProvider
final screenIndexProvider = StateProvider<int>((ref) => 0);
final chanceProvider = StateProvider<int>((ref) => 30);
final dataLengthProvider = StateProvider<int>((ref) => 0);
final completedAlbumProvider = StateProvider<int>((ref) => 0);
final numberAlbumProvider = StateProvider<int>((ref) => 0);
final reward1Provider = StateProvider<double>((ref) => 0.0);
final reward2Provider = StateProvider<double>((ref) => 0.0);
final reward3Provider = StateProvider<double>((ref) => 0.0);
final reward4Provider = StateProvider<double>((ref) => 0.0);
final latitudeProvider = StateProvider<String>((ref) => "");
final longitudeProvider = StateProvider<String>((ref) => "");
final mnemonicPhraseProvider = StateProvider<String>((ref) => "");
final contractAddressProvider = StateProvider<String>((ref) => "");
final passwordStatesProvider = StateProvider<bool>((ref) => false);
final confirmPasswordStatesProvider = StateProvider<bool>((ref) => false);
final mnemonicPhraseStatesProvider = StateProvider<bool>((ref) => false);
