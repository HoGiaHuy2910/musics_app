import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget sectionTitle(String text) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 0.8,
          ),
        ),
      );
    }

    Widget arrowTile({
      required IconData icon,
      required String title,
      String? subtitle,
    }) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title sẽ làm sau'),
              duration: const Duration(milliseconds: 900),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // ================= ACCOUNT =================
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=3', // 👉 hình giả
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hồ Gia Huy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Free account',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),

          // ================= APPEARANCE =================
          sectionTitle('Appearance'),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            subtitle: const Text('Giao diện tối'),
            value: false,
            onChanged: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dark mode sẽ làm sau'),
                  duration: Duration(milliseconds: 800),
                ),
              );
            },
          ),

          arrowTile(
            icon: Icons.palette_outlined,
            title: 'Theme color',
            subtitle: 'Màu chủ đạo',
          ),

          arrowTile(
            icon: Icons.text_fields,
            title: 'Font size',
            subtitle: 'Kích thước chữ',
          ),

          const Divider(),

          // ================= LIBRARY =================
          sectionTitle('Library'),

          arrowTile(
            icon: Icons.favorite_border,
            title: 'Favorites',
            subtitle: 'Bài hát & album đã thích',
          ),

          arrowTile(
            icon: Icons.queue_music,
            title: 'Playlists',
            subtitle: 'Danh sách phát của bạn',
          ),

          arrowTile(
            icon: Icons.person_outline,
            title: 'Following artists',
            subtitle: 'Nghệ sĩ bạn quan tâm',
          ),

          const Divider(),

          // ================= CONTACT =================
          sectionTitle('Contact'),

          arrowTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'hogiahuy@example.com',
          ),

          arrowTile(
            icon: Icons.support_agent_outlined,
            title: 'Support',
            subtitle: 'Liên hệ hỗ trợ',
          ),

          arrowTile(
            icon: Icons.bug_report_outlined,
            title: 'Report a bug',
            subtitle: 'Báo lỗi ứng dụng',
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout sẽ làm sau'),
                    duration: Duration(milliseconds: 900),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
