import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameCtrl = TextEditingController();
  final _avatarCtrl = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  late final String uid;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser!;
    uid = user.uid;
    _email = user.email ?? '';

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = snap.data();

    _nameCtrl.text = data?['displayName'] ?? '';
    _avatarCtrl.text = data?['accImage'] ?? '';

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'displayName': _nameCtrl.text.trim(),
      'accImage': _avatarCtrl.text.trim(),
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ===== AVATAR PREVIEW =====
            CircleAvatar(
              radius: 52,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _avatarCtrl.text.isNotEmpty
                  ? NetworkImage(_avatarCtrl.text)
                  : null,
              child: _avatarCtrl.text.isEmpty
                  ? const Icon(Icons.person, size: 48)
                  : null,
            ),

            const SizedBox(height: 20),

            // ===== EMAIL (READ ONLY) =====
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              controller: TextEditingController(text: _email),
              readOnly: true,
            ),

            const SizedBox(height: 16),

            // ===== DISPLAY NAME =====
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Display name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ===== AVATAR URL =====
            TextField(
              controller: _avatarCtrl,
              decoration: const InputDecoration(
                labelText: 'Avatar image URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 24),

            // ===== SAVE BUTTON =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Save changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
