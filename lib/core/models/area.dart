class Area {
  final String name;

  Area({required this.name});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      name: json['strArea'] as String,
    );
  }

  static List<Area> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Area.fromJson(json)).toList();
  }
}
