import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hoopula/services/gameService.dart';

final gameProvider =
    ChangeNotifierProvider<GameService>((ref) => GameService());
