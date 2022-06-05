enum UserType { judge, vooter }

class UserModel {
  static UserType? userType = UserType.judge;
}

class CandidatesUser {
  String? name;
  int? id;
  int? ssn;
  String? birthDate;
  String? plan;
  int? circleId;
  String? image;
  bool isSelected;

  CandidatesUser(this.name, this.id, this.ssn, this.birthDate, this.plan,
      this.circleId, this.image, this.isSelected);

  factory CandidatesUser.fromJson(Map<String, dynamic> json) {
    return CandidatesUser(
      json['f_name'],
      json['id'],
      json['SSN'],
      json['b_date'],
      json['plan'],
      json['circ_id'],
      json['photo'] == null
          ? 'https://cdn-icons-png.flaticon.com/512/4305/4305692.png'
          : json['photo'],
      false,
    );
  }

  @override
  String toString() {
    return '${this.name} ${this.id} ${this.ssn} ${this.birthDate} ${this.plan} ${this.circleId} ${this.image}';
  }
}

class VooterUser {
  int? ssn;
  String? name;
  String? address;
  String? image;

  VooterUser(this.ssn, this.name, this.address, this.image);

  factory VooterUser.fromJson(Map<String, dynamic> json) {
    return VooterUser(json['SSN'], json['f_name'], json['adress'],
        'https://cdn-icons-png.flaticon.com/512/4305/4305692.png');
  }
}
