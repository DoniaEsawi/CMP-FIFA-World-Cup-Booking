class TicketModel {
  String? matchId;
  String? seatNumber;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  TicketModel(
      {this.matchId,
        this.seatNumber,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id});

  TicketModel.fromJson(Map<String, dynamic> json) {
    matchId = json['match_id'].toString();
    seatNumber = json['seat_number'].toString();
    userId = json['user_id'];
    updatedAt = json['updated_at'].toString();
    createdAt = json['created_at'].toString();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['match_id'] = matchId;
    data['seat_number'] = seatNumber;
    data['user_id'] = userId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}