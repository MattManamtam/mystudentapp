// add_student.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'model.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String course = '';
  String year = 'First Year';  // Default value
  bool enrolled = false;

  bool _isLoading = false; // To show loading indicator during API call

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Student'),
      ),
      body: SingleChildScrollView( // Make form scrollable
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // First Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  firstName = value!;
                },
              ),
              SizedBox(height: 16),
              // Last Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  lastName = value!;
                },
              ),
              SizedBox(height: 16),
              // Course
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course';
                  }
                  return null;
                },
                onSaved: (value) {
                  course = value!;
                },
              ),
              SizedBox(height: 16),
              // Year Dropdown
              DropdownButtonFormField<String>(
                value: year,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                items: ['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
                    .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    year = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),
              // Enrolled Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enrolled',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: enrolled,
                    onChanged: (bool newValue) {
                      setState(() {
                        enrolled = newValue;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.secondary, // Use colorScheme.secondary
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Add Student Button
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        Student newStudent = Student(
                          firstName: firstName,
                          lastName: lastName,
                          course: course,
                          year: year,
                          enrolled: enrolled,
                        );
                        await ApiService().createStudent(newStudent);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Student added successfully')),
                        );
                        Navigator.pop(context, true);  // Pass true to indicate success
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add student: $e')),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: _isLoading ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ) : Text('Add Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
