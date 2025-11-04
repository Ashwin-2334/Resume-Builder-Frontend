import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ProjectsPage extends StatefulWidget {
  final String name;
  final String jobTitle;
  final Map<String, String> personalDetails;
  final Map<String, String> education;
  final List<String> skills;

  ProjectsPage({
    required this.name,
    required this.jobTitle,
    required this.personalDetails,
    required this.education,
    required this.skills,
  });

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectDescriptionController = TextEditingController();
  final TextEditingController _technologiesUsedController = TextEditingController();
  List<Map<String, String>> projects = []; // List to store projects

  void _addProject() {
    final projectTitle = _projectTitleController.text.trim();
    final projectDescription = _projectDescriptionController.text.trim();
    final technologiesUsed = _technologiesUsedController.text.trim();

    if (projectTitle.isNotEmpty && projectDescription.isNotEmpty && technologiesUsed.isNotEmpty) {
      setState(() {
        projects.add({
          "title": projectTitle,
          "description": projectDescription,
          "technologies": technologiesUsed,
        });
        _projectTitleController.clear();
        _projectDescriptionController.clear();
        _technologiesUsedController.clear();
      });
    }
  }

  void _generatePDF() async {
  try {
    // Prepare form data
    Map<String, String> bodyData = {
      "name": widget.name,
      "jobTitle": widget.jobTitle,
      ...widget.personalDetails,
      ...widget.education,
      "skills": widget.skills.join(","), // Convert skills to a comma-separated string
    };

    // Convert projects to form data format
    for (int i = 0; i < projects.length; i++) {
      bodyData["proj${i + 1}_title"] = projects[i]["title"]!;
      bodyData["proj${i + 1}_description"] = projects[i]["description"]!;
      bodyData["proj${i + 1}_technologies"] = projects[i]["technologies"]!;
    }

    final response = await http.post(
      Uri.parse('${dotenv.env['YOUR_IP']}/generate-pdf'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: bodyData,
    );

    if (response.statusCode == 200) {
      final Uint8List pdfBytes = response.bodyBytes;
      final String path = (await getTemporaryDirectory()).path;
      final File file = File('$path/profile.pdf');
      await file.writeAsBytes(pdfBytes);

      OpenFile.open(file.path);
    } else {
      print('Failed to generate PDF: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF')),
      );
    }
  } catch (e) {
    print('Error generating PDF: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Projects')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Display existing projects
                  ...projects.map((project) {
                    return ListTile(
                      title: Text(project["title"]!),
                      subtitle: Text(project["description"]!),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            projects.remove(project);
                          });
                        },
                      ),
                    );
                  }).toList(),

                  // Input fields for new project
                  TextField(
                    controller: _projectTitleController,
                    decoration: InputDecoration(labelText: 'Project Title'),
                  ),
                  TextField(
                    controller: _projectDescriptionController,
                    decoration: InputDecoration(labelText: 'Project Description'),
                  ),
                  TextField(
                    controller: _technologiesUsedController,
                    decoration: InputDecoration(labelText: 'Technologies Used'),
                  ),
                  ElevatedButton(
                    onPressed: _addProject,
                    child: Text('Add Project'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _generatePDF,
              child: Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }
}