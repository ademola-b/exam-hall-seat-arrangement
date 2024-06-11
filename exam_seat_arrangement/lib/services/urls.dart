String baseUrl = "http://192.168.43.130:8000";
// String baseUrl = "http://demolab.pythonanywhere.com/";
// loginUrl
Uri loginUrl = Uri.parse("$baseUrl/api/accounts/login/");
Uri userUrl = Uri.parse("$baseUrl/api/accounts/user/");
Uri addStudentUrl = Uri.parse("$baseUrl/api/accounts/add-student/");
Uri invigilatorUrl = Uri.parse("$baseUrl/api/accounts/invigilator/");
Uri addHallUrl = Uri.parse("$baseUrl/api/exam-seat/add-hall/");
Uri hallsUrl = Uri.parse("$baseUrl/api/exam-seat/halls/");
Uri coursesUrl = Uri.parse("$baseUrl/api/exam-seat/courses/");
Uri allocateHallUrl = Uri.parse("$baseUrl/api/exam-seat/allocate-hall/");
Uri allocationsUrl = Uri.parse("$baseUrl/api/exam-seat/allocations/");
Uri passwordChangeUrl = Uri.parse("$baseUrl/api/accounts/password/change/");
