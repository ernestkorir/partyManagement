class Guest {
  String id;
  String name;
  String foodPreference;

  Guest({required this.id, required this.name, required this.foodPreference});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'foodPreference': foodPreference,
    };
  }

  factory Guest.fromJson(Map<String, dynamic> json, String id) {
    return Guest(
      id: id,
      name: json['name'],
      foodPreference: json['foodPreference'],
    );
  }
}