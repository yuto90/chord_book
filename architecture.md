# MVVM アーキテクチャドキュメント

## **1. アーキテクチャ概要**

### **1.1 MVVMパターンの採用理由**

本プロジェクトでは、以下の理由からMVVM（Model-View-ViewModel）パターンを採用します：

- **関心の分離**: UI、ビジネスロジック、データの責務を明確に分離
- **テスタビリティ**: ViewModelの単体テストが容易
- **保守性**: 各レイヤーの独立性により、変更の影響範囲を限定
- **再利用性**: ViewModelとModelの再利用が可能
- **Flutterとの親和性**: Riverpodとの組み合わせで自然な実装が可能

### **1.2 レイヤー構成と責務**

```
┌─────────────────────────────────────────────────┐
│                   View Layer                     │
│         (Widgets, Screens, UI Components)        │
└─────────────────┬───────────────────────────────┘
                  │ 監視・イベント
┌─────────────────▼───────────────────────────────┐
│              ViewModel Layer                     │
│    (State Management, Business Logic)            │
│         (Riverpod + Freezed)                     │
└─────────────────┬───────────────────────────────┘
                  │ データ要求
┌─────────────────▼───────────────────────────────┐
│              Repository Layer                    │
│         (Data Access Abstraction)                │
└─────────────────┬───────────────────────────────┘
                  │ 
┌─────────────────▼───────────────────────────────┐
│           Service/Data Source Layer              │
│    (Database, API, File System, Services)        │
└─────────────────────────────────────────────────┘
```

## **2. レイヤー詳細定義**

### **2.1 View Layer（UI層）**

**責務**
- UIの描画とレイアウト
- ユーザー入力の受付
- ViewModelの状態監視と画面更新
- ナビゲーション処理

**実装ルール**
- ビジネスロジックを含まない
- `ConsumerWidget`または`ConsumerStatefulWidget`を使用
- ViewModelの状態を`ref.watch`で監視
- ユーザーアクションを`ref.read`でViewModelに伝達

**例**
```dart
class LibraryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryViewModelProvider);
    
    return state.when(
      data: (songs) => SongListView(songs: songs),
      loading: () => LoadingIndicator(),
      error: (error, _) => ErrorView(error: error),
    );
  }
}
```

### **2.2 ViewModel Layer（プレゼンテーション層）**

**責務**
- Viewの状態管理
- ビジネスロジックの実装
- Repositoryとの連携
- データの変換と整形
- バリデーション処理

**実装ルール**
- `StateNotifier`、`AsyncNotifier`、または`Notifier`を継承
- 状態はFreezedで定義した不変クラス
- 副作用のないメソッドを心がける
- エラーハンドリングの実装

**例**
```dart
@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  @override
  Future<List<Song>> build() async {
    return ref.watch(songRepositoryProvider).getAllSongs();
  }
  
  Future<void> deleteSong(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(songRepositoryProvider).deleteSong(id);
      return ref.read(songRepositoryProvider).getAllSongs();
    });
  }
}
```

### **2.3 Model Layer（データ層）**

**責務**
- データ構造の定義
- ビジネスエンティティの表現
- JSONシリアライゼーション

**実装ルール**
- Freezedで不変クラスとして定義
- ビジネスロジックは含まない
- `fromJson`/`toJson`メソッドの自動生成

**例**
```dart
@freezed
class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    String? artist,
    @Default(120) int bpm,
    required DateTime createdAt,
  }) = _Song;
  
  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
```

### **2.4 Repository Layer（データアクセス層）**

**責務**
- データソースの抽象化
- データアクセスロジック
- キャッシュ戦略の実装
- 複数データソースの統合

**実装ルール**
- インターフェースと実装を分離
- データソースの詳細を隠蔽
- エラーハンドリング

**例**
```dart
abstract class SongRepository {
  Future<List<Song>> getAllSongs();
  Future<Song?> getSong(String id);
  Future<void> saveSong(Song song);
  Future<void> deleteSong(String id);
}

class SongRepositoryImpl implements SongRepository {
  final AppDatabase _database;
  
  SongRepositoryImpl(this._database);
  
  @override
  Future<List<Song>> getAllSongs() async {
    final songs = await _database.songDao.getAllSongs();
    return songs.map((e) => e.toModel()).toList();
  }
}
```

### **2.5 Service Layer（ビジネスロジック層）**

**責務**
- 特定機能のカプセル化
- 外部サービスとの連携
- 複雑なビジネスロジック
- ユーティリティ機能

**実装ルール**
- 単一責任の原則
- 状態を持たない
- 再利用可能な設計

**例**
```dart
class MetronomeService {
  Stream<BeatEvent> startMetronome(int bpm, String timeSignature) {
    // メトロノーム実装
  }
}
```

## **3. ディレクトリ構成**

### **3.1 構成概要**

```
lib/
├── main.dart                    # エントリーポイント
├── app.dart                     # アプリケーション定義
├── router/                      # ルーティング
├── core/                        # 共通機能・ユーティリティ
├── models/                      # データモデル（Freezed）
├── providers/                   # グローバルProvider
├── repositories/                # データアクセス層
├── services/                    # ビジネスロジック・外部サービス
├── database/                    # データベース定義
├── viewmodels/                  # ViewModel層
├── views/                       # UI層
└── l10n/                        # 国際化（将来対応）
```

### **3.2 詳細構成**

#### **Core（共通機能）**
```
構成例：
core/
├── constants/                   # 定数定義
│   ├── app_colors.dart         # カラー定数
│   ├── app_sizes.dart          # サイズ定数
│   └── app_strings.dart        # 文字列定数
├── theme/                       # テーマ設定
│   ├── app_theme.dart          # アプリテーマ
│   └── text_styles.dart        # テキストスタイル
├── extensions/                  # 拡張メソッド
│   └── context_extensions.dart # BuildContext拡張
├── utils/                       # ユーティリティ
│   ├── logger.dart             # ログ出力
│   └── validators.dart         # バリデーション
└── exceptions/                  # 例外定義
    └── app_exception.dart      # カスタム例外
```

#### **Models（データモデル）**
構成例：
```
models/
├── song/                        # 楽曲関連
│   └── song.dart               # 楽曲モデル
├── setlist/                     # セットリスト関連
│   ├── setlist.dart            # セットリストモデル
│   └── setlist_item.dart       # セットリストアイテム
├── chord/                       # コード関連
│   ├── chord_shape.dart        # コード指板図
│   └── chord_block.dart        # コードブロック
├── playback/                    # 演奏関連
│   ├── playback_state.dart     # 演奏状態
│   └── beat_event.dart         # ビートイベント
└── enums/                       # 列挙型
    └── chord_block_type.dart   # コードブロックタイプ
```

#### **ViewModels（プレゼンテーション層）**
構成例：
```
viewmodels/
├── library/                     # 楽曲一覧
│   ├── library_viewmodel.dart  # 楽曲一覧VM
│   └── library_state.dart      # 楽曲一覧状態
├── editor/                      # エディタ
│   ├── song_editor_viewmodel.dart # エディタVM
│   └── editor_state.dart       # エディタ状態
├── playback/                    # 演奏モード
│   ├── playback_viewmodel.dart # 演奏VM
│   └── metronome_viewmodel.dart # メトロノームVM
└── setlist/                     # セットリスト
    └── setlist_viewmodel.dart  # セットリストVM
```

#### **Views（UI層）**
構成例：
```
views/
├── screens/                     # 画面
│   ├── library/                # 楽曲一覧画面
│   │   ├── library_screen.dart
│   │   └── widgets/            # 画面固有Widget
│   ├── editor/                 # エディタ画面
│   │   ├── song_editor_screen.dart
│   │   └── widgets/
│   ├── playback/               # 演奏画面
│   │   ├── playback_screen.dart
│   │   └── widgets/
│   └── setlist/                # セットリスト画面
│       ├── setlist_screen.dart
│       └── widgets/
└── common/                      # 共通Widget
    ├── adaptive_scaffold.dart  # レスポンシブScaffold
    ├── loading_indicator.dart  # ローディング表示
    └── error_view.dart         # エラー表示
```

## **4. 状態管理（Riverpod + Freezed）**

### **4.1 Provider種別と使い分け**

#### **Provider**
基本的な依存性注入、不変の値やサービスインスタンスの提供
```dart
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}
```

#### **StateNotifierProvider**
複雑な状態管理が必要な場合
```dart
@riverpod
class SongEditor extends _$SongEditor {
  @override
  SongEditorState build() {
    return const SongEditorState();
  }
  
  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }
}
```

#### **FutureProvider / StreamProvider**
非同期データの取得
```dart
@riverpod
Future<List<Song>> songList(SongListRef ref) async {
  final repository = ref.watch(songRepositoryProvider);
  return repository.getAllSongs();
}
```

### **4.2 Freezedによる状態定義**

```dart
@freezed
class LibraryState with _$LibraryState {
  const factory LibraryState({
    @Default([]) List<Song> songs,
    @Default('') String searchQuery,
    @Default(SortType.title) SortType sortType,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _LibraryState;
}
```

## **5. 命名規則**

### **5.1 ファイル名**
- snake_case: `song_editor_screen.dart`
- Freezedファイル: `song.freezed.dart`, `song.g.dart`

### **5.2 クラス名**
- PascalCase: `SongEditorViewModel`
- Provider: `songEditorViewModelProvider`

### **5.3 ディレクトリ名**
- snake_case: `view_models/`, `song_editor/`

## **6. 依存関係の方向**

```
View → ViewModel → Repository → Service/Database
         ↓
       Model
```

**重要な原則**
- 上位レイヤーは下位レイヤーに依存する
- 下位レイヤーは上位レイヤーを知らない
- 横方向の依存は避ける

## **7. テスト戦略**

### **7.1 テストディレクトリ構成**
```
test/
├── unit/                        # 単体テスト
│   ├── services/               # サービステスト
│   ├── repositories/           # リポジトリテスト
│   └── viewmodels/            # ViewModelテスト
├── widget/                      # Widgetテスト
│   ├── screens/               # 画面テスト
│   └── common/                # 共通Widgetテスト
└── integration/                 # 統合テスト
```

### **7.2 テスト対象と方針**
- **ViewModel**: ビジネスロジックの単体テスト（最重要）
- **Service**: 機能単位の単体テスト
- **Repository**: モック化したデータソースでのテスト
- **Widget**: 重要なUIコンポーネントのテスト

## **8. ベストプラクティス**

### **8.1 ViewModelの設計**
- 1画面1ViewModel を基本とする
- 複雑な画面は機能単位で分割
- UIロジックとビジネスロジックを分離

### **8.2 状態管理**
- 状態は常にイミュータブル
- `copyWith`メソッドで状態更新
- 副作用は`ref.listen`で処理

### **8.3 エラーハンドリング**
- ViewModelレベルでエラー処理
- ユーザーフレンドリーなエラーメッセージ
- リトライ機能の実装

### **8.4 パフォーマンス**
- 必要な部分のみ`ref.watch`
- `select`で細かい購読制御
- 重い処理は`AsyncValue`で非同期化
