class Area {
  final String name;

  Area({required this.name});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      name: json['strArea'] as String,
    );
  }
}
