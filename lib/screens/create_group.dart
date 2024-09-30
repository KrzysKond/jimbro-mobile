import 'package:flutter/material.dart';
import 'package:jimbro_mobile/service/api_group_service.dart';
import '../../service/api_workout_service.dart';

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm({super.key});

  @override
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      final success = await ApiGroupService().createGroup(_nameController.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Group Created')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create group')));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Group", style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Group Name',
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white70),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed:(){
                      _createGroup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Create Group',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
