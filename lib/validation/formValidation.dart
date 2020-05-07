
class Validate {

  String validateStringText(String value) {
    //  String patttern = r'(^[a-zA-Z ]*$)';
    //  RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Please fill the field";
    }
    return null;
  }


  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    }
    return null;
  }

  String validateConfirmPassword(String value, String value2) {
    if (value.length == 0) {
      return "please enter password again";
    } else if (value != value2) {
      return "Password do not match ";
    }
    return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

}
