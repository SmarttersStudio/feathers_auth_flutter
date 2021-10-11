part of feathers_auth_flutter;

FeathersError featherErrorFromJson(String str) =>
    FeathersError.fromJson(json.decode(str));

String featherErrorToJson(FeathersError data) => json.encode(data.toJson());

class FeathersError {
  String? name;
  String? message;
  int? code;
  bool? isRestError;
  bool? result;

  FeathersError(
      {this.name, this.message, this.code, this.isRestError, this.result});
  factory FeathersError.noInternet(
          {String? name,
          String? message,
          int? code,
          bool? isRestError,
          bool? result}) =>
      FeathersError(
          message: message ?? 'Error while connecting',
          code: code ?? 0,
          name: name ?? 'No Internet',
          result: result ?? false,
          isRestError: isRestError ?? false);

  factory FeathersError.fromJson(Map<String, dynamic> json) => FeathersError(
      name: json["name"] ?? '',
      message: json["message"] ?? '',
      code: json["code"] ?? 0,
      isRestError: json["isRestError"] ?? false,
      result: json['result'] ?? (json["code"] == 200 || json["code"] == 201));

  @override
  String toString() => message ?? "Some error occurred";

  Map<String, dynamic> toJson() => {
        "name": name,
        "message": message,
        "code": code,
        "isRestError": isRestError
      };
}
