import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';

final databaseProvider = Provider((ref) => AppDatabase());
