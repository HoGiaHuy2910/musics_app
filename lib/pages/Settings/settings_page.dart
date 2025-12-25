import 'package:flutter/material.dart';
import '../../controllers/audio_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // ===== PLAYBACK =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Playback',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ValueListenableBuilder<bool>(
            valueListenable: audio.isRepeatOne,
            builder: (_, repeat, __) {
              return SwitchListTile(
                title: const Text('Repeat one song'),
                subtitle: const Text('Lặp lại bài đang phát'),
                value: repeat,
                onChanged: (_) {
                  audio.toggleRepeat();
                },
              );
            },
          ),

          ListTile(
            title: const Text('Shuffle'),
            subtitle: const Text('Xáo trộn danh sách phát'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Shuffle sẽ làm sau'),
                ),
              );
            },
          ),

          const Divider(),

          // ===== APP =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'App',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Giao diện tối'),
            value: false,
            onChanged: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dark mode làm sau'),
                ),
              );
            },
          ),

          const Divider(),

          // ===== DATA =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Data & Storage',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear cache'),
            subtitle: const Text('Xoá dữ liệu tạm'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache hiện chưa có'),
                ),
              );
            },
          ),

          const Divider(),

          // ===== ABOUT =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          const ListTile(
            title: Text('App version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
