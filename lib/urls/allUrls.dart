class Constants {
  static String baseUrl = "https://subset.in/api/";

  //static String baseUrl = "http://192.168.43.183/api/";
  final String studentProfileUpload =
      baseUrl + "comman/student_profile_upload.php";
  final String teacherProfileUpload =
      baseUrl + "comman/teacher_profile_upload.php";
  final String login = baseUrl + "comman/login.php";
  final String apply = baseUrl + "comman/apply.php";
  final String coachingapply = baseUrl + "subsetAdmin/apply.php";
  final String updateToken = baseUrl + "comman/updateToken.php";
  final String uploadNotes = baseUrl + "subsetAdmin/upload_notes.php";
  final String fetchNotes = baseUrl + "subsetAdmin/fetch/fetchNotes.php";

  final String chooseCoachingList =
      baseUrl + "comman/fetchCoachingListAddmission.php";
  final String chooseBatchList =
      baseUrl + "subsetAdmin/batches/read_batches.php";
  final String chooseCoachingToContinue =
      baseUrl + "comman/registeredCoachingList.php";
  final String profile = baseUrl + "comman/profile.php";
  final String notice = baseUrl + "comman/add/notice.php";
  final String addcomment = baseUrl + "comman/add/comment.php";
  final String questionLike = baseUrl + "comman/add/questionLike.php";
  final String addanswer = baseUrl + "comman/add/answer.php";
  final String addquestion = baseUrl + "comman/add/question.php";
  final String addcoachingcomment = baseUrl + "comman/add/coachingComments.php";

  //---------------IMPORT LIST URLS---------------------------
  final String noticeListStudent = baseUrl + "student/getNotice.php";
  final String noticeListTeacher = baseUrl + "teacher/getNotice.php";
  final String noticeComments = baseUrl + "comman/getComments.php";
  final String questionListStudent = baseUrl + "student/getQuestions.php";
  final String questionListTeacher = baseUrl + "teacher/getQuestions.php";
  final String questionComments = baseUrl + "comman/getAnswers.php";
  final String subjectList = baseUrl + "comman/getSubjects.php";
  final String testList = baseUrl + "comman/getTestList.php";
  final String createTest = baseUrl + "subsetAdmin/createTest.php";
  //--------------DETAILS URLS---------------------------------
  final String noticeDetails = baseUrl + "comman/noticeInfo.php";
  final String questionDetails = baseUrl + "comman/getQuestionInfo.php";
  //-------------IMAGES LINKS-----------------------------
  final String profileImage = baseUrl + "images/profile/";
  final String coachinglogo = baseUrl + "images/logo/";
  final String coachingimage = baseUrl + "images/coaching_img/";
  final String questionimage = baseUrl + "images/questions/";
  final String answerimage = baseUrl + "images/answer/";
  final String noticeimage = baseUrl + "images/notice/";
  final String notesPDF = baseUrl + "images/notes/";

  //-----------ATTENDANCE AND RESULT---------------------------------
  final String fetchResult = baseUrl + "student/getResult.php";

  final String fetchBatches = baseUrl + "teacher/attendance/batchList.php";
  final String fetchSubjects = baseUrl + "comman/getSubjects.php";
  final String studentListForAttendance =
      baseUrl + "teacher/attendance/studentListAttendance.php";
  final String submitAttendance = baseUrl + "teacher/attendance.php";
  final String submitResult = baseUrl + "teacher/uploadResultUpdate.php";
  final String fetchAttendance = baseUrl + "student/getAttendance.php";
  final String fetchLocation = baseUrl + "comman/fetch/location.php";
  final String createLocation =
      baseUrl + "subsetAdmin/admin/createLoaction.php";
  final String fetchCount = baseUrl + "subsetAdmin/fetch/closeadminssion.php";
  final String updateBatchName = baseUrl + "comman/update/batch_update.php";
  final String updateComment = baseUrl + "comman/update/update_comment.php";
  final String deleteComment = baseUrl + "comman/delete/delete_comment.php";
  final String updateAnswer = baseUrl + "comman/update/update_answer.php";
  final String deleteNotification =
      baseUrl + "comman/delete/delete_notification.php"; //id
  final String childrenList = baseUrl + "comman/fetch/childrenList.php";
  final String fetchClassesWithID =
      baseUrl + "subsetAdmin/fetch/fetchClassesWithID.php";

  //----------------------ADMIN OPERATIONS------------------------------
  final String adminLogin = baseUrl + "subsetAdmin/login.php";
  final String fetchClasses = baseUrl + "subsetAdmin/fetch/fetchClasses.php";
  final String createBatches = baseUrl + "subsetAdmin/batches/create_batch.php";
  final String fetchStudent = baseUrl + "subsetAdmin/fetch/students.php";
  final String fetchTeacher = baseUrl + "subsetAdmin/fetch/teachers.php";
  final String fetchNotification =
      baseUrl + "subsetAdmin/fetch/fetchNotificaton.php";
  final String sendNotification = baseUrl + "subsetAdmin/notification.php";
  final String fetchAdminNotice = baseUrl + "subsetAdmin/fetch/fetchNotice.php";
  final String fetchRequests = baseUrl + "subsetAdmin/fetch/requests.php";
  final String fetchRequestsHandler =
      baseUrl + "subsetAdmin/requestHandler.php";
  final String fetchCoachingInfo =
      baseUrl + "subsetAdmin/fetch/coachingInfo.php";
  final String fetchCoachingComments =
      baseUrl + "comman/getCoachingComments.php";

  final String updateCoaching = baseUrl + "subsetAdmin/update.php";
}
