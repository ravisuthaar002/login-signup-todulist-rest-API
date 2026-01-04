import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'rest_api.dart';
import 'view_model/user_preference/user_preference_view_modal.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  final CollectionReference _tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  final UserPreference _userPreference = UserPreference();

  Future<bool> _addTask() async {
  final title = _titleCtrl.text.trim();
  final desc = _descCtrl.text.trim();

  if (title.isEmpty) return false;

  try {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    _titleCtrl.clear();
    _descCtrl.clear();
    await _tasksRef.add({
      'title': title,
      'description': desc,
      'createdAt': FieldValue.serverTimestamp(),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });

    return true;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

  Future<void> _deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks / Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.http),
            onPressed: () => Get.to(() => const ExampleTwo()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await _userPreference.removeUser();
              Get.offAll(() => login_screen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _titleCtrl,
                  focusNode: _titleFocusNode, // ✅ FIXED
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _titleCtrl,
                    builder: (_, value, __) {
                      return ElevatedButton(
                        onPressed: value.text.trim().isEmpty
                            ? null
                            : () async {
                                final ok = await _addTask();
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Task saved'),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasksRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading tasks'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No tasks yet'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final ts = data['createdAt'];
                    String when = '';

                    if (ts is Timestamp) {
                      when = DateFormat('yyyy-MM-dd HH:mm')
                          .format(ts.toDate());
                    }

                    return ListTile(
                      title: Text(data['title'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((data['description'] ?? '').isNotEmpty)
                            Text(data['description']),
                          if (when.isNotEmpty)
                            Text(
                              when,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteTask(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
