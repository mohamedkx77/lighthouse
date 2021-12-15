library queen_map;

import 'package:collection/collection.dart';

/// * merges to maps into single one
/// * if the key found in both maps it will use the one from the second map
dynamic mergeTwoMaps(dynamic a, dynamic b) {
  if (a is Map<String, Object?> && b is Map<String, Object?>) {
    return mergeMaps<String, dynamic>(a, b, value: mergeTwoMaps);
  }
  return b;
}

Object? findInMap(
  String path,
  Map map, {
  String splitOperator = '.',
}) {
  /// extract if no parent
  if (!path.contains('.')) return map[path];

  /// split and remove empty
  final keys = path.split('.')..removeWhere((e) => e.isEmpty);

  /// if the key is nested
  if (keys.isNotEmpty) {
    if (keys.length == 1) return map[keys.first];
    final firstKey = keys.first;
    final value = map[firstKey];
    if (value is Map) {
      final newKey = path.replaceFirst('$firstKey.', '');
      return findInMap(
        newKey,
        value,
        splitOperator: splitOperator,
      );
    }
  }
}

List<String> flatMapKeys(Map<String, Object?> map) {
  /// full flat list
  final List<String> flatKeys = <String>[];

  for (final key in map.keys) {
    final value = map[key];
    flatKeys.add(key);

    if (value is Map) {
      final children = flatMapKeys(value as Map<String, Object?>);
      flatKeys.addAll(children.map((e) => '$key.$e'));
    }
  }

  return flatKeys;
}
