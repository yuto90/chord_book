import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/song/song.dart';
import '../../../viewmodels/song/song_editor_viewmodel.dart';
import '../../widgets/song_editor_form_widget.dart';

class SongEditorScreen extends ConsumerStatefulWidget {
  final Song? song;

  const SongEditorScreen({
    super.key,
    this.song,
  });

  @override
  ConsumerState<SongEditorScreen> createState() => _SongEditorScreenState();
}

class _SongEditorScreenState extends ConsumerState<SongEditorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(songEditorViewModelProvider.notifier);
      if (widget.song != null) {
        notifier.loadSong(widget.song!);
        notifier.startEditing();
      } else {
        notifier.createNewSong();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(songEditorViewModelProvider);
    final notifier = ref.read(songEditorViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song == null ? '新しいコード譜' : 'コード譜を編集'),
        actions: [
          if (state.hasUnsavedChanges)
            TextButton(
              onPressed: () async {
                await notifier.saveSong();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('保存しました')),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: state.currentSong == null
          ? const Center(child: CircularProgressIndicator())
          : SongEditorFormWidget(
              song: state.currentSong!,
              onSongChanged: (updatedSong) {
                // Handle song updates through the view model
              },
            ),
    );
  }

  @override
  void dispose() {
    // Check for unsaved changes before leaving
    final state = ref.read(songEditorViewModelProvider);
    if (state.hasUnsavedChanges) {
      // Could show a dialog here in a real implementation
    }
    super.dispose();
  }
}