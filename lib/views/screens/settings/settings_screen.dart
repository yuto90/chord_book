import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const Text(
            '設定',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // App version
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('アプリバージョン'),
              subtitle: const Text('0.1.0'),
            ),
          ),
          
          // General settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('テーマ'),
                  subtitle: const Text('ライト'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement theme selection
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('言語'),
                  subtitle: const Text('日本語'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement language selection
                  },
                ),
              ],
            ),
          ),
          
          // Metronome settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text('メトロノーム設定'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('デフォルトBPM'),
                  subtitle: const Text('120'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement BPM setting
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('デフォルト拍子'),
                  subtitle: const Text('4/4'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement time signature setting
                  },
                ),
              ],
            ),
          ),
          
          // About
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('ヘルプ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement help
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('利用規約'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement terms
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('プライバシーポリシー'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement privacy policy
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}