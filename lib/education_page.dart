import 'package:flutter/material.dart';
import 'select_skills_page.dart'; // Import the next page

class EducationPage extends StatefulWidget {
  final String name;
  final String jobTitle;
  final Map<String, String> personalDetails;

  EducationPage({
    required this.name,
    required this.jobTitle,
    required this.personalDetails,
  });

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final TextEditingController _edu1DegreeController = TextEditingController();
  final TextEditingController _edu1CollegeController = TextEditingController();
  final TextEditingController _edu1YearController = TextEditingController();
  final TextEditingController _edu1GradeController = TextEditingController();

  final TextEditingController _edu2DegreeController = TextEditingController();
  final TextEditingController _edu2CollegeController = TextEditingController();
  final TextEditingController _edu2YearController = TextEditingController();
  final TextEditingController _edu2GradeController = TextEditingController();

  void _goToSkillsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectSkillsPage(
          name: widget.name,
          jobTitle: widget.jobTitle,
          personalDetails: widget.personalDetails,
          education: {
            "edu1_degree": _edu1DegreeController.text.trim(),
            "edu1_college": _edu1CollegeController.text.trim(),
            "edu1_year": _edu1YearController.text.trim(),
            "edu1_grade": _edu1GradeController.text.trim(),
            "edu2_degree": _edu2DegreeController.text.trim(),
            "edu2_college": _edu2CollegeController.text.trim(),
            "edu2_year": _edu2YearController.text.trim(),
            "edu2_grade": _edu2GradeController.text.trim(),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Education Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Education 1", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _edu1DegreeController,
                decoration: InputDecoration(labelText: 'Degree'),
              ),
              TextField(
                controller: _edu1CollegeController,
                decoration: InputDecoration(labelText: 'College'),
              ),
              TextField(
                controller: _edu1YearController,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              TextField(
                controller: _edu1GradeController,
                decoration: InputDecoration(labelText: 'Grade'),
              ),
              SizedBox(height: 20),
              Text("Education 2", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _edu2DegreeController,
                decoration: InputDecoration(labelText: 'Degree'),
              ),
              TextField(
                controller: _edu2CollegeController,
                decoration: InputDecoration(labelText: 'College'),
              ),
              TextField(
                controller: _edu2YearController,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              TextField(
                controller: _edu2GradeController,
                decoration: InputDecoration(labelText: 'Grade'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToSkillsPage,
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}