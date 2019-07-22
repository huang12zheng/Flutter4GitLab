import 'package:common_utils/common_utils.dart';


// -----------------------------------Login-------------------------------
Map<String, String> getLoginArg(String access,String verify) {
  if (access == '') throw new Exception('please input account');
  if (verify == '') throw new Exception('please input verify info');
  Map<String,String> queryArg={};
  switchAccess(access, queryArg);
  switchVerify(verify, queryArg);
  return queryArg;
}

void switchAccess(String access, Map<String, String> map) {
  if (RegexUtil.isEmail(access)==true) {map['email']=access; return ;}
  if (RegexUtil.isMobileExact(access)==true) {map['mobile']=access; return;}
  { map['username']=access; return ;}
}

void switchVerify(String verify, Map<String, String> map) {
  if (verify.length==6 && RegExp('[0-9]+').hasMatch(verify) ) { map['SMS']=verify; return ;}
  map['password']=verify; return;
}


// -----------------------------------Signup-------------------------------
switchPostArg({String access,String password,String mobile,String email}){
  if (access == '') throw new Exception('please input account');
  if (password == '') throw new Exception('please input password info');
  if (mobile == '') throw new Exception('please input mobile');
  if (email == '') throw new Exception('please input email');
  Map<String,String> arg = {
    "username": access,
    "password": password,
    "skype":    mobile,
    "name":     access,
    "email":    email
  };
  return arg;
}
getSignupArg(Map<String,String> userInfo){
  return switchPostArg(
    access: userInfo['username'],
    password: userInfo['password'],
    mobile: userInfo['mobile'],
    email: userInfo['email']
  );
}
void passwordCheck(Map<String, String> userInfo) {
  if (userInfo['password']!= userInfo['confirm-password']) throw Exception('please check password');
}