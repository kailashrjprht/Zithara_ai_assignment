class DateFormatModel {
  final int id;
  final String datetype;
  final bool enabled;

  DateFormatModel({
    required this.id,
    required this.datetype,
    required this.enabled,
  });

  factory DateFormatModel.fromJson(Map<String, dynamic> json) {
    return DateFormatModel(
      id: json['id'],
      datetype: json['datetype'],
      enabled: json['enabled'],
    );
  }
}
