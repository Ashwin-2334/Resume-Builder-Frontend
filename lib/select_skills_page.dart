import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'projects_page.dart'; // Import the ProjectsPage
import 'experience_page.dart'; // Import the ExperiencePage
import 'package:flutter_dotenv/flutter_dotenv.dart';


class SelectSkillsPage extends StatefulWidget {
  final String name;
  final String jobTitle;
  final Map<String, String> personalDetails;
  final Map<String, String> education;


  SelectSkillsPage({
    required this.name,
    required this.jobTitle,
    required this.personalDetails,
    required this.education,
  });

  @override
  _SelectSkillsPageState createState() => _SelectSkillsPageState();
}

class _SelectSkillsPageState extends State<SelectSkillsPage> {
  List<String> skills = [];
  List<bool> selectedSkills = [];
  final TextEditingController _customSkillController = TextEditingController();
  List<String> customSkills = [];
  bool isExperienced = false; // Track if the user is experienced

  @override
  void initState() {
    super.initState();
    _fetchSkills();
  }

  Future<void> _fetchSkills() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['YOUR_IP']}/get-skills'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"jobTitle": widget.jobTitle},
      );

      if (response.statusCode == 200) {
        setState(() {
          skills = List<String>.from(jsonDecode(response.body)["skills"]);
          selectedSkills = List<bool>.filled(skills.length, false);
        });
      }
    } catch (e) {
      print("Error fetching skills: $e");
    }
  }

  void _addCustomSkill() {
    final customSkill = _customSkillController.text.trim();
    if (customSkill.isNotEmpty) {
      setState(() {
        customSkills.add(customSkill);
        _customSkillController.clear();
      });
    }
  }

  void _goToNextPage() {
    // Collect selected skills
    List<String> chosenSkills = [];
    for (int i = 0; i < skills.length; i++) {
      if (selectedSkills[i]) {
        chosenSkills.add(skills[i]);
      }
    }
    chosenSkills.addAll(customSkills);

    // Navigate to the appropriate page
    if (isExperienced) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExperiencePage(
            name: widget.name,
            jobTitle: widget.jobTitle,
            personalDetails: widget.personalDetails,
            education: widget.education,
            skills: chosenSkills,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectsPage(
            name: widget.name,
            jobTitle: widget.jobTitle,
            personalDetails: widget.personalDetails,
            education: widget.education,
            skills: chosenSkills,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Skills')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle for fresher/experienced
            Row(
              children: [
                Text('Are you experienced?'),
                Switch(
                  value: isExperienced,
                  onChanged: (value) {
                    setState(() {
                      isExperienced = value;
                    });
                  },
                ),
              ],
            ),

            if (skills.isEmpty)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: [
                    // Display AI-generated skills with checkboxes
                    ...skills.map((skill) {
                      final index = skills.indexOf(skill);
                      return CheckboxListTile(
                        title: Text(skill),
                        value: selectedSkills[index],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedSkills[index] = value ?? false;
                          });
                        },
                      );
                    }).toList(),

                    // Display custom skills
                    ...customSkills.map((skill) {
                      return ListTile(
                        title: Text(skill),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              customSkills.remove(skill);
                            });
                          },
                        ),
                      );
                    }).toList(),

                    // Text field and button for adding custom skills
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customSkillController,
                              decoration: InputDecoration(
                                labelText: 'Add Custom Skill',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _addCustomSkill,
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _goToNextPage,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}