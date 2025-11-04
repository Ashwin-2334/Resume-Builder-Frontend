import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ExperiencePage extends StatefulWidget {
  final String name;
  final String jobTitle;
  final Map<String, String> personalDetails;
  final Map<String, String> education;
  final List<String> skills;

  ExperiencePage({
    required this.name,
    required this.jobTitle,
    required this.personalDetails,
    required this.education,
    required this.skills,
  });

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Map<String, String>> experiences = []; // List to store experiences

  void _addExperience() {
    final company = _companyController.text.trim();
    final years = _yearsController.text.trim();
    final description = _descriptionController.text.trim();

    if (company.isNotEmpty && years.isNotEmpty && description.isNotEmpty) {
      setState(() {
        experiences.add({
          "company": company,
          "years": years,
          "description": description,
        });
        _companyController.clear();
        _yearsController.clear();
        _descriptionController.clear();
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

    // Convert experiences to form data format
    for (int i = 0; i < experiences.length; i++) {
      bodyData["exp${i + 1}_company"] = experiences[i]["company"]!;
      bodyData["exp${i + 1}_years"] = experiences[i]["years"]!;
      bodyData["exp${i + 1}_description"] = experiences[i]["description"]!;
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
      appBar: AppBar(title: Text('Add Experience')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Display existing experiences
                  ...experiences.map((experience) {
                    return ListTile(
                      title: Text(experience["company"]!),
                      subtitle: Text(experience["description"]!),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            experiences.remove(experience);
                          });
                        },
                      ),
                    );
                  }).toList(),

                  // Input fields for new experience
                  TextField(
                    controller: _companyController,
                    decoration: InputDecoration(labelText: 'Company'),
                  ),
                  TextField(
                    controller: _yearsController,
                    decoration: InputDecoration(labelText: 'Years of Experience'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  ElevatedButton(
                    onPressed: _addExperience,
                    child: Text('Add Experience'),
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