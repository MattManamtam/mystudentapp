// list_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'model.dart';
import 'student_detail.dart';  // For navigating to the detail screen
import 'add_student.dart';  // For adding a new student

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = ApiService().getStudents();  // Fetch students when the screen loads
  }

  // Function to refresh the student list
  Future<void> _refreshStudents() async {
    setState(() {
      futureStudents = ApiService().getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students List'),
      ),
      body: FutureBuilder<List<Student>>(
        future: futureStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No data message
            return Center(child: Text('No students found'));
          } else {
            // List of students
            return RefreshIndicator(
              onRefresh: _refreshStudents,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Student student = snapshot.data![index];
                  return Card(
                    color: Colors.lightBlue[50],  // Light sky blue background
                    elevation: 3,  // Slight elevation
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary, // Use secondary color
                        child: Text(
                          student.firstName[0] + student.lastName[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        '${student.firstName} ${student.lastName}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${student.course} • ${student.year}',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Icon(
                        student.enrolled ? Icons.check_circle : Icons.cancel,
                        color: student.enrolled ? Colors.green : Colors.red,
                      ),
                      onTap: () async {
                        // Navigate to detail screen and wait for potential updates
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetailScreen(student: student),
                          ),
                        );
                        if (result == true) {
                          _refreshStudents();  // Refresh list if a change was made
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary, // Use colorScheme.secondary
        onPressed: () async {
          // Navigate to add student screen and wait for result
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );
          if (result == true) {
            _refreshStudents();  // Refresh list if a student was added
          }
        },
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Student',
      ),
    );
  }
}
