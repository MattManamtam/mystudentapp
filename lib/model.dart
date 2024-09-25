class Student {
  int? id;
  String firstName;
  String lastName;
  String course;
  String year;
  bool enrolled;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      course: json['course'],
      year: json['year'],
      enrolled: json['enrolled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'year': year,
      'enrolled': enrolled,
    };
  }
}
