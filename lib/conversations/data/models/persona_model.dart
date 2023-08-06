class PersonaModel {
  String? firstName;
  String? lastName;
  List<String>? hobbies;
  String? country;
  String? timezone;
  String? city;
  String? description;
  String? image;
  bool? isAvailable;
  String? status;
  int? age;

  PersonaModel(
      {this.firstName,
      this.lastName,
      this.hobbies,
      this.country,
      this.timezone,
      this.city,
      this.description,
      this.image,
      this.isAvailable,
      this.status,
      this.age});
  static const String kKeyFirstName = 'firstName';
  static const String kKeyLastName = 'lastName';
  static const String kKeyHobbies = 'hobbies';
  static const String kKeyDescription = 'description';
  static const String kKeyImage = 'image';
  static const String kKeyIsAvailable = 'isAvailable';
  static const String kKeyStatus = 'status';
  static const String kKeyAge = "age";
  static const String kKeyCountry = 'country';
  static const String kKeyTimezone = 'timezone';
  static const String kKeyCity = 'city';

  /// fyi: for status keys:
  static const String kKeyActive = "active";
  static const String kKeyInactive = "inactive";
  static const String kKeyNotificationOff = "notification_off";

  PersonaModel.fromJson(Map<String, dynamic> json) {
    firstName = json[kKeyFirstName]?.trim();
    lastName = json[kKeyLastName]?.trim();
    hobbies = json[kKeyHobbies].cast<String>();
    country = json[kKeyCountry]?.trim();
    timezone = json[kKeyTimezone]?.trim();
    city = json[kKeyCity]?.trim();
    description = json[kKeyDescription]?.trim();
    image = json[kKeyImage];
    isAvailable = json[kKeyIsAvailable];
    status = json[kKeyStatus];
    age = json[kKeyAge];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[kKeyFirstName] = this.firstName;
    data[kKeyLastName] = this.lastName;
    data[kKeyHobbies] = this.hobbies;
    data[kKeyCountry] = this.country;
    data[kKeyTimezone] = this.timezone;
    data[kKeyCity] = this.city;
    data[kKeyDescription] = this.description;
    data[kKeyImage] = this.image;
    data[kKeyIsAvailable] = this.isAvailable;
    data[kKeyStatus] = this.status;
    data[kKeyAge] = this.age;
    return data;
  }
}
