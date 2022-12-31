class StadiumModel {
  int? id;
  String? location;
  String? name;
  String? numberOfRows;
  String? numberOfColumns;
  String? createdAt;
  String? updatedAt;

  StadiumModel(
      {this.id,
        this.location,
        this.name,
        this.numberOfRows,
        this.numberOfColumns,
        this.createdAt,
        this.updatedAt});

  StadiumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    name = json['name'];
    numberOfRows = json['number_of_rows'].toString();
    numberOfColumns = json['number_of_columns'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location'] = location;
    data['name'] = name;
    data['number_of_rows'] = numberOfRows.toString();
    data['number_of_columns'] = numberOfColumns.toString();
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}