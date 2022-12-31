// ignore_for_file: unnecessary_question_mark

class User {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? nationality;
  String? gender;
  String? role;
  int? beManager;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? token;

  User(
      {this.id,
        this.username,
        this.firstName,
        this.lastName,
        this.birthDate,
        this.nationality,
        this.gender,
        this.role,
        this.beManager,
        this.email,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    birthDate = json['birth_date'];
    nationality = json['nationality'];
    gender = json['gender'];
    role = json['role'];
    beManager = json['be_manager'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['birth_date'] = birthDate;
    data['nationality'] = nationality;
    data['gender'] = gender;
    data['role'] = role;
    data['be_manager'] = beManager;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}