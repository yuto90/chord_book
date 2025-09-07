import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/song/song_list_viewmodel.dart';
import 'song_detail_screen.dart';
import 'song_editor_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songListAsync = ref.watch(songListViewModelProvider);

    return Scaffold(
      body: songListAsync.when(
        data: (songs) {
          if (songs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'コード譜がありません',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '右下の + ボタンから作成してください',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (song.artist != null)
                        Text(song.artist!),
                      const SizedBox(height: 4),
                      Text(
                        '${song.lyricLines.length}行 • ${_formatDate(song.updatedAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SongEditorScreen(song: song),
                          ),
                        );
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, ref, song.id, song.title);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('編集'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('削除', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SongDetailScreen(song: song),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('エラーが発生しました: $error'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SongEditorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays > 0) {
      return '${diff.inDays}日前';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}時間前';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}分前';
    } else {
      return 'たった今';
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String songId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除確認'),
        content: Text('「$title」を削除しますか？この操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(songListViewModelProvider.notifier).deleteSong(songId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('コード譜を削除しました')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}