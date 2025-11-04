import 'package:flutter/material.dart';
import 'personal_details_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Profile Generator')),
        body: ProfileGenerator(),
      ),
    );
  }
}

class ProfileGenerator extends StatefulWidget {
  @override
  _ProfileGeneratorState createState() => _ProfileGeneratorState();
}

class _ProfileGeneratorState extends State<ProfileGenerator> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();

  void _goToPersonalDetailsPage() {
    if (_nameController.text.isEmpty || _jobTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name and job title')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalDetailsPage(
          name: _nameController.text,
          jobTitle: _jobTitleController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
              ),
              TextField(
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToPersonalDetailsPage,
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
