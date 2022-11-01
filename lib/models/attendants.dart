import 'dart:convert';

class Attendants {
  String? code;
  String? userCode;
  String? branch;
  String? datetime;
  String? serviceDesk;

  Attendants({
    this.code,
    this.userCode,
    this.branch,
    this.datetime,
    this.serviceDesk,
  });

  static const _code = 'code';
  static const _userCode = 'userCode';
  static const _branch = 'branch';
  static const _dt = 'date';
  static const _serviceDesk = 'serviceDesk';

  Attendants.fromJson(Map<String, dynamic> json) {
    code = json[_code] ?? '';
    userCode = json[_userCode] ?? '';
    branch = json[_branch] ?? '';
    datetime = json[_dt] ?? '';
    serviceDesk = json[_serviceDesk] ?? '';
  }

  List<Attendants> toList(List json) =>
      json.map((e) => Attendants.fromJson(e)).toList();

  static Map<String, dynamic> jsonify(String data) {
    return json.decode(data);
  }
}
