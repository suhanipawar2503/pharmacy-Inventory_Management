class Distributor {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String gstNumber;
  final String email;

  Distributor({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.gstNumber,
    required this.email,
  });

  Distributor copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? gstNumber,
    String? email,
  }) {
    return Distributor(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'gstNumber': gstNumber,
      'email': email,
    };
  }

  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      gstNumber: json['gstNumber'],
      email: json['email'],
    );
  }
}
