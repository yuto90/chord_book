# 簡易版CI/CDセットアップガイド

## 概要

従来版では8つのGitHub Secretsが必要でしたが、この簡易版では**わずか3つのSecrets**でTestFlightへの自動デプロイメントが可能です。

## 必要なGitHub Secrets（3つのみ！）

### 1. App Store Connect API関連

#### `APP_STORE_CONNECT_API_KEY_ID`
- **説明**: App Store Connect API Key ID
- **取得方法**: 
  1. [App Store Connect](https://appstoreconnect.apple.com/) にログイン
  2. 「ユーザとアクセス」→「キー」→「App Store Connect API」
  3. 新しいキーを作成（Developer権限以上）
  4. Key IDをコピー

#### `APP_STORE_CONNECT_API_ISSUER_ID`
- **説明**: App Store Connect API Issuer ID
- **取得方法**: 
  1. App Store Connect APIキーページの上部にある「Issuer ID」をコピー

#### `APP_STORE_CONNECT_API_KEY`
- **説明**: API Key ファイル（.p8）のBase64エンコード版
- **取得方法**:
  1. APIキー作成時にダウンロードした`.p8`ファイルを準備
  2. 以下のコマンドでBase64エンコード:
     ```bash
     base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
     ```
  3. クリップボードの内容をSecretに設定

## セットアップ手順

### 1. GitHub Secretsの設定

1. GitHubリポジトリの「Settings」→「Secrets and variables」→「Actions」
2. 「New repository secret」で以下の3つを追加:
   - `APP_STORE_CONNECT_API_KEY_ID`
   - `APP_STORE_CONNECT_API_ISSUER_ID`
   - `APP_STORE_CONNECT_API_KEY`

### 2. iOS設定の確認

1. **自動署名の有効化**:
   - Xcodeでプロジェクトを開く
   - Runner ターゲットの「Signing & Capabilities」
   - 「Automatically manage signing」をチェック
   - Team を設定

2. **Bundle Identifier の確認**:
   - `com.chordbook.chordBook` が設定されていることを確認

### 3. TestFlightの確認

1. App Store Connect で「マイApp」→「Chord Book」
2. TestFlightタブで内部テストグループを設定
3. 必要に応じて外部テストグループも設定

## 使用方法

### フィーチャーブランチでのテスト
```bash
git checkout -b feature/new-feature
git push origin feature/new-feature
```

### PR作成での自動ビルド
- PR作成時に自動でCI/CDが実行
- ビルド完了後、PRにコメントで通知

### 手動実行
- GitHubの「Actions」タブから「Simplified Debug Build」を選択
- 「Run workflow」で手動実行可能

## 従来版との比較

| 項目 | 従来版 | 簡易版 |
|------|--------|--------|
| 必要なSecrets | 8個 | 3個 |
| 証明書管理 | 手動（.p12ファイル） | 自動（Xcode管理） |
| プロビジョニングプロファイル | 手動設定 | 自動生成 |
| キーチェーン管理 | 必要 | 不要 |
| セットアップ難易度 | 難しい | 簡単 |

## トラブルシューティング

### ビルドが失敗する場合

1. **署名エラー**:
   - App Store Connect でアプリが登録されているか確認
   - Bundle Identifier が正しいか確認
   - チームメンバーシップが有効か確認

2. **API権限エラー**:
   - API Keyの権限が「Developer」以上か確認
   - API Keyが有効期限内か確認

3. **Flutter環境エラー**:
   - `pubspec.yaml` の Flutter バージョンが対応しているか確認
   - 依存関係が正しく解決されるか確認

## セキュリティのメリット

- **証明書ファイルの直接管理が不要**: Apple IDでの自動署名により、機密性の高い証明書ファイルを直接扱う必要がありません
- **最小権限の原則**: App Store Connect APIのみの権限で動作します
- **一時ファイルが残らない**: キーチェーンや証明書ファイルの一時保存が不要です

## 注意事項

- 初回は手動でXcodeからApp Store Connectにアプリをアップロードしている必要があります
- 自動署名を使用するため、開発用証明書が自動生成される場合があります
- API Keyは適切に管理し、定期的にローテーションすることを推奨します

---

✨ この簡易版により、CI/CDの設定が大幅に簡単になり、メンテナンスコストも削減されます！