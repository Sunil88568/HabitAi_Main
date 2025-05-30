class NotificationModel {
  int? statusCode;
  String? message;
  List<Data>? data;

  NotificationModel({this.statusCode, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? title;
  String? message;
  bool? isRead;
  String? userId;
  String? createdAt;
  int? iV;
  String? updatedAt;

  Data(
      {this.sId,
        this.title,
        this.message,
        this.isRead,
        this.userId,
        this.createdAt,
        this.iV,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    message = json['message'];
    isRead = json['isRead'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['isRead'] = this.isRead;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
