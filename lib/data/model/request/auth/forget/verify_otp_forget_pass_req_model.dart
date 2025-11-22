class VerifyOtpForgetPassReqModel {
  String? email;
  int? otp;

  VerifyOtpForgetPassReqModel({this.email, this.otp});

  VerifyOtpForgetPassReqModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['otp'] = this.otp;
    return data;
  }
}
