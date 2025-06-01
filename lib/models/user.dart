import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String username;
  final String image;
  final Address address;
  final Company company;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username,
    required this.image,
    required this.address,
    required this.company,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      username: json['username'] ?? '',
      image: json['image'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      company: Company.fromJson(json['company'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'username': username,
      'image': image,
      'address': address.toJson(),
      'company': company.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    username,
    image,
    address,
    company,
  ];
}

class Address extends Equatable {
  final String address;
  final String city;
  final String state;
  final String stateCode;
  final String postalCode;
  final Coordinates coordinates;
  final String country;

  const Address({
    required this.address,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.coordinates,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      stateCode: json['stateCode'] ?? '',
      postalCode: json['postalCode'] ?? '',
      coordinates: Coordinates.fromJson(json['coordinates'] ?? {}),
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'stateCode': stateCode,
      'postalCode': postalCode,
      'coordinates': coordinates.toJson(),
      'country': country,
    };
  }

  @override
  List<Object?> get props => [
    address,
    city,
    state,
    stateCode,
    postalCode,
    coordinates,
    country,
  ];
}

class Coordinates extends Equatable {
  final double lat;
  final double lng;

  const Coordinates({
    required this.lat,
    required this.lng,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  @override
  List<Object?> get props => [lat, lng];
}

class Company extends Equatable {
  final String department;
  final String name;
  final String title;
  final Address address;

  const Company({
    required this.department,
    required this.name,
    required this.title,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      department: json['department'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'name': name,
      'title': title,
      'address': address.toJson(),
    };
  }

  @override
  List<Object?> get props => [department, name, title, address];
}

class UsersResponse extends Equatable {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;

  const UsersResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      users: (json['users'] as List<dynamic>?)
          ?.map((user) => User.fromJson(user))
          .toList() ??
          [],
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [users, total, skip, limit];
}