class UserNotification {
  String? id;
  String? dateTime;
  bool? isOn;

  UserNotification({
    this.id,
    this.dateTime,
    this.isOn,
  });

  UserNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = json['dateTime'];
    isOn = json['isOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dateTime'] = dateTime;
    data['isOn'] = isOn;
    return data;
  }

  @override
  String toString() {
    return 'UserNotification: { id: $id, dateTime: $dateTime, isOn: $isOn }';
  }
}
