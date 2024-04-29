class APIEndPoint{

  APIEndPoint._();

  static const String baseUrl= 'https://api.emploihunt.com/api';
  // static const String baseUrl= 'http://191.232.33.124:5000/api';

  static const String privacyPolicy = "/terms-privacy-policy/get_terms_policy_by_id?id=1";
  static const String  termsAndCondition = '/terms-privacy-policy/get_terms_policy_by_id?id=2';
  static const String  getLatestAppVersionCode = '/update_app/get_latest_app_version_code';
  static const String  getLocationsList = '/city/cities';
  static const String  splashUpdateApp = '/update_app/get_latest_app_version_code?iUserId=0';
  static const String  checkUserExisting = '/signin/check_user_existing?mobile=%2B';
  static const String  loginApi = '/signin/login';
  static const String  registerUserApi = '/signin/register_user';
  static const String  signOutApi = '/signin/signout';
  static const String  deleteAccountApi = '/user/delete';


  ///------------------------------------- job seeker ------------------------------///

  static const String  jobPostApi = '/job/jobs?iJobPreferenceId=';
  static const String  jobAppliedApi = '/job/apply?jobId=';
  static const String  saveJobApi = '/job/save?jobId=';
  static const String  unSaveJobApi = '/job/unSave?jobId=';

  static const String  campusPlacementApi = '/campus_placement/campus?';
  static const String  campusPlacementAppliedApi = '/campus_placement/apply?campusId=';


  static const String  saveListApi = '/job/saveList?';
  static const String  appliedListApi = '/job/applyList?';

  static const String  contactUsApi = '/contact-us/insert_user_contact';


  static const String  jobPreferenceApi = '/jobPreference/jobPreference';
  static const String  jobPreferenceInsertApi = '/jobPreference/insert_preference';
  static const String  jobPreferenceUpdateApi = '/jobPreference/update_preference';

///------------------------------------- job seeker ------------------------------///

///------------------------------------- Profile --------------------------------///
    static const String userExperienceApi = '/experince/experince';
    static const String userExperienceInsertApi = '/experince/insert_experince';
    static const String userExperienceUpdateApi = '/experince/update_experince';
    static const String userExperienceDeleteApi = '/experince/delete_experince';
    static const String userUpdateProfileDetailsApi = '/user/update_profile_details';
    static const String userUpdateBannerPicApi = '/user/update_banner_pic';
    static const String userUpdateProfilePicApi = '/user/update_profile_pic';
    static const String userUpdateResumeApi = '/user/update_resume';

    static const String getRecruiterApi = '/recruiter/get_recruiter';
///------------------------------------- Profile --------------------------------///

  ///------------------------------------- job seeker ------------------------------///

///--------------------------------- Recruiter ------------------------------------///

  static const String getJobSeekerApi = '/jobSeeker/get_jobSeeker';
  ///---------------------------- Jobs ---------------------------------///

  static const String jobInsertApi = '/job/insert_jobs';
  static const String jobUpdateApi = '/job/update_jobs';
  static const String jobGetJobByHrIdApi = '/job/jobs_by_hrId';
  static const String jobDeleteApi = '/job/delete';

  static const String jobsByHrIdWOPagination = '/job/jobs_by_hrId_withoutpagination';
  static const String getAppliedUserByTagApi = '/jobSeeker/get_applied_jobSeeker';
  static const String getAppliedUserExpByIdApi = '/experince/get_experince_by_id';

  ///---------------------------- Jobs ---------------------------------///
///--------------------------------- Recruiter ------------------------------------///

///----------------------------------Filter---------------------------------///

  ///---------------- Recruiter ----------///
  static const String getJobSeekerFilterApiApi = '/jobSeeker/get_jobSeeker_filter';

  ///---------- job seeker module ------///
  static const String jobFilterApi = '/job/jobs_filter';

///----------------------------------Filter---------------------------------///

  static const String getUserByFirebaseId = '/user/get_user_by_firebaseId';

}