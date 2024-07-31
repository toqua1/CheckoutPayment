// import 'dart:convert';

// import 'package:collection/collection.dart';

// class AssociatedObject {
//   String? id;
//   String? type;

//   AssociatedObject({this.id, this.type});

//   factory AssociatedObject.fromMap(Map<String, dynamic> data) {
//     return AssociatedObject(
//       id: data['id'] as String?,
//       type: data['type'] as String?,
//     );
//   }

//   Map<String, dynamic> toMap() => {
//         'id': id,
//         'type': type,
//       };

//   /// `dart:convert`
//   ///
//   /// Parses the string and returns the resulting Json object as [AssociatedObject].
//   factory AssociatedObject.fromJson(String data) {
//     return AssociatedObject.fromMap(json.decode(data) as Map<String, dynamic>);
//   }

//   /// `dart:convert`
//   ///
//   /// Converts [AssociatedObject] to a JSON string.
//   String toJson() => json.encode(toMap());

//   @override
//   bool operator ==(Object other) {
//     if (identical(other, this)) return true;
//     if (other is! AssociatedObject) return false;
//     final mapEquals = const DeepCollectionEquality().equals;
//     return mapEquals(other.toMap(), toMap());
//   }

//   @override
//   int get hashCode => id.hashCode ^ type.hashCode;
// }
class AssociatedObject {
  String? id;
  String? type;

  AssociatedObject({this.id, this.type});

  factory AssociatedObject.fromJson(Map<String, dynamic> json) {
    return AssociatedObject(
      id: json['id'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
      };
}
