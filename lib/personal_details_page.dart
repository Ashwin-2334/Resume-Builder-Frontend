import 'package:flutter/material.dart';
import 'education_page.dart'; // Import the next page

class PersonalDetailsPage extends StatefulWidget {
  final String name;
  final String jobTitle;

  PersonalDetailsPage({
    required this.name,
    required this.jobTitle,
  });

  @override
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  void _goToEducationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EducationPage(
          name: widget.name,
          jobTitle: widget.jobTitle,
          personalDetails: {
            "phone": _phoneController.text.trim(),
            "email": _emailController.text.trim(),
            "github": _githubController.text.trim(),
            "linkedin": _linkedinController.text.trim(),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number (optional)'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email (optional)'),
              ),
              TextField(
                controller: _githubController,
                decoration: InputDecoration(labelText: 'GitHub Profile (optional)'),
              ),
              TextField(
                controller: _linkedinController,
                decoration: InputDecoration(labelText: 'LinkedIn Profile (optional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToEducationPage,
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}