import 'package:flutter/material.dart';
import 'package:jimbro_mobile/models/group.dart';
import '../service/api_group_service.dart';

class SearchGroupScreen extends StatefulWidget {
  @override
  _SearchGroupScreenState createState() => _SearchGroupScreenState();
}

class _SearchGroupScreenState extends State<SearchGroupScreen> {
  late Future<List<Group>> _allGroupsFuture;
  List<Group> _filteredGroups = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allGroupsFuture = ApiGroupService().fetchAllGroups();
  }

  void _filterGroups(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _joinGroup(Group group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Join Group ${group.name}'),
          content: Text('Are you sure you want to join ${group.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ApiGroupService().joinGroup(group.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully joined the group!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to join the group: $e')),
                  );
                }
              },
              child: Text('Join'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Groups',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              onChanged: _filterGroups,
              decoration: InputDecoration(
                labelText: 'Search Groups',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Group>>(
                future: _allGroupsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No groups found.'));
                  }

                  final allGroups = snapshot.data!;
                  _filteredGroups = allGroups
                      .where((group) => group.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();

                  if (_filteredGroups.isEmpty) {
                    return const Center(child: Text('No matching groups found.'));
                  }

                  return ListView.builder(
                    itemCount: _filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = _filteredGroups[index];

                      // Get the number of members in the group
                      final memberCount = group.members.length;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(
                            group.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.purpleAccent,
                            ),
                          ),
                          subtitle: Text(
                            'Members: $memberCount',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            _joinGroup(group);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
