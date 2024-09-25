// student_detail.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'model.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;

  StudentDetailScreen({required this.student});

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late Student student;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    student = widget.student;  // Get student data passed from the previous screen
  }

  void _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await ApiService().updateStudent(student.id!, student);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student updated successfully')),
        );
        Navigator.pop(context, true);  // Pass true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update student: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _deleteStudent() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm) {
      setState(() {
        _isLoading = true;
      });
      try {
        await ApiService().deleteStudent(student.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student deleted successfully')),
        );
        Navigator.pop(context, true);  // Pass true to indicate deletion
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete student: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${student.firstName} ${student.lastName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _isLoading ? null : _deleteStudent,
            tooltip: 'Delete Student',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Make form scrollable
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name
                    TextFormField(
                      initialValue: student.firstName,
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
                        student.firstName = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    // Last Name
                    TextFormField(
                      initialValue: student.lastName,
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
                        student.lastName = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    // Course
                    TextFormField(
                      initialValue: student.course,
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
                        student.course = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    // Year Dropdown
                    DropdownButtonFormField<String>(
                      value: student.year,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      items: ['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
                          .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          student.year = newValue!;
                        });
                      },
                      onSaved: (newValue) {
                        student.year = newValue!;
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
                          value: student.enrolled,
                          onChanged: (bool newValue) {
                            setState(() {
                              student.enrolled = newValue;
                            });
                          },
                          activeColor: Theme.of(context).colorScheme.secondary, // Use colorScheme.secondary
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    // Update Button
                    SizedBox(
                      width: double.infinity, // Make button full width
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateStudent,
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text('Update Student'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
