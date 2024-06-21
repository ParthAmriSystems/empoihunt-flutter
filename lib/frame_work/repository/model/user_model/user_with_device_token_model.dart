class UserWithDeviceTokenModel {
  final int? id;
  final String? vFirebaseId;
  final int? iRole;
  final String? vFirstName;
  final String? vLastName;
  final String? vMobile;
  final String? vEmail;
  final String? tProfileUrl;
  final String? tProfileBannerUrl;
  final String? tResumeUrl;
  final String? tVideoResumeUrl;
  final String? vCity;
  final String? tBio;
  final String? vCurrentCompany;
  final String? vDesignation;
  final String? vJobLocation;
  final String? vDuration;
  final String? vPreferCity;
  final String? vPreferJobTitle;
  final String? vQualification;
  final String? vWorkingMode;
  final String? tTagLine;
  final String? googleid;
  final String? fbid;
  final int? isBlock;
  final int? isLogin;
  final String? tCreatedAt;
  final String? tUpadatedAt;
  final String? tDeviceToken;

  UserWithDeviceTokenModel({
    this.id,
    this.vFirebaseId,
    this.iRole,
    this.vFirstName,
    this.vLastName,
    this.vMobile,
    this.vEmail,
    this.tProfileUrl,
    this.tProfileBannerUrl,
    this.tResumeUrl,
    this.tVideoResumeUrl,
    this.vCity,
    this.tBio,
    this.vCurrentCompany,
    this.vDesignation,
    this.vJobLocation,
    this.vDuration,
    this.vPreferCity,
    this.vPreferJobTitle,
    this.vQualification,
    this.vWorkingMode,
    this.tTagLine,
    this.googleid,
    this.fbid,
    this.isBlock,
    this.isLogin,
    this.tCreatedAt,
    this.tUpadatedAt,
    this.tDeviceToken,
  });
  factory UserWithDeviceTokenModel.fromJson(Map<String, dynamic> json) {
    return UserWithDeviceTokenModel(
      id: json['id'] as int?,
      vFirebaseId: json['vFirebaseId'] as String?,
      iRole: json['iRole'] as int?,
      vFirstName: json['vFirstName'] as String?,
      vLastName: json['vLastName'] as String?,
      vMobile: json['vMobile'] as String?,
      vEmail: json['vEmail'] as String?,
      tProfileUrl: json['tProfileUrl'] as String?,
      tProfileBannerUrl: json['tProfileBannerUrl'] as String?,
      tResumeUrl: json['tResumeUrl'] as String?,
      tVideoResumeUrl: json['tVideoResumeUrl'] as String?,
      vCity: json['vCity'] as String?,
      tBio: json['tBio'] as String?,
      vCurrentCompany: json['vCurrentCompany'] as String?,
      vDesignation: json['vDesignation'] as String?,
      vJobLocation: json['vJobLocation'] as String?,
      vDuration: json['vDuration'] as String?,
      vPreferCity: json['vPreferCity'] as String?,
      vPreferJobTitle: json['vPreferJobTitle'] as String?,
      vQualification: json['vQualification'] as String?,
      vWorkingMode: json['vWorkingMode'] as String?,
      tTagLine: json['tTagLine'] as String?,
      googleid: json['googleid'] as String?,
      fbid: json['fbid'] as String?,
      isBlock: json['isBlock'] as int?,
      isLogin: json['isLogin'] as int?,
      tCreatedAt: json['tCreatedAt'] as String?,
      tUpadatedAt: json['tUpadatedAt'] as String?,
      tDeviceToken: json['tDeviceToken'] as String?,
    );
  }

  // Create a method to convert a ChatUserModel instance to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vFirebaseId': vFirebaseId,
      'iRole': iRole,
      'vFirstName': vFirstName,
      'vLastName': vLastName,
      'vMobile': vMobile,
      'vEmail': vEmail,
      'tProfileUrl': tProfileUrl,
      'tProfileBannerUrl': tProfileBannerUrl,
      'tResumeUrl': tResumeUrl,
      'tVideoResumeUrl': tVideoResumeUrl,
      'vCity': vCity,
      'tBio': tBio,
      'vCurrentCompany': vCurrentCompany,
      'vDesignation': vDesignation,
      'vJobLocation': vJobLocation,
      'vDuration': vDuration,
      'vPreferCity': vPreferCity,
      'vPreferJobTitle': vPreferJobTitle,
      'vQualification': vQualification,
      'vWorkingMode': vWorkingMode,
      'tTagLine': tTagLine,
      'googleid': googleid,
      'fbid': fbid,
      'isBlock': isBlock,
      'isLogin': isLogin,
      'tCreatedAt': tCreatedAt,
      'tUpadatedAt': tUpadatedAt,
      'tDeviceToken': tDeviceToken,
    };
  }
}
