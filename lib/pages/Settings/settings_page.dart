import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Playlist/my_playlists_page.dart';
import '../Like/like_page.dart';
import '../Following/following_page.dart';
import '../Profile/edit_profile_page.dart';
import '../../main.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Widget sectionTitle(String text) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
      );
    }

    Widget arrowTile({
      required IconData icon,
      required String title,
      String? subtitle,
      VoidCallback? onTap,
    }) {
      return ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          final displayName =
              data?['displayName'] ?? user.email ?? 'Unknown user';
          final accImage = data?['accImage'] as String?;

          return ListView(
            children: [
              // ================= ACCOUNT =================
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfilePage(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                        accImage != null ? NetworkImage(accImage) : null,
                        child: accImage == null
                            ? const Icon(Icons.person, size: 42)
                            : null,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),

              // ================= APPEARANCE =================
              sectionTitle('Appearance'),

              /// 🌙 DARK MODE
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark mode'),
                subtitle: const Text('Giao diện tối'),
                value: Theme.of(context).brightness == Brightness.dark,

                // 🎨 MÀU TRACK (NỀN)
                activeTrackColor: Colors.amberAccent.withOpacity(0.6),
                inactiveTrackColor: Colors.grey.shade400,

                // 🎨 MÀU NÚT TRÒN
                activeColor: Colors.amberAccent,
                inactiveThumbColor: Colors.white,

                onChanged: (value) {
                  MyApp.of(context).toggleDarkMode(value);
                },
              ),
              // ================= LIBRARY =================
              sectionTitle('Library'),

              arrowTile(
                icon: Icons.favorite_border,
                title: 'Favorites',
                subtitle: 'Bài hát & album đã thích',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LikePage()),
                  );
                },
              ),

              arrowTile(
                icon: Icons.queue_music,
                title: 'My playlists',
                subtitle: 'Tạo playlist theo sở thích của bạn',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyPlaylistsPage(),
                    ),
                  );
                },
              ),

              arrowTile(
                icon: Icons.person_outline,
                title: 'Following artists',
                subtitle: 'Nghệ sĩ bạn quan tâm',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FollowingPage(),
                    ),
                  );
                },
              ),

              const Divider(),

              // ================= ABOUT =================
              sectionTitle('About'),

              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('App version'),
                trailing: Text('1.0.0'),
              ),

              arrowTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy policy',
              ),

              arrowTile(
                icon: Icons.description_outlined,
                title: 'Terms of service',
              ),

              arrowTile(
                icon: Icons.code,
                title: 'Open source licenses',
              ),

              const Divider(),

              // ================= LOGOUT =================
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
