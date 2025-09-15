# デバッグ用CI/CD基盤実装ドキュメント

## 概要

このドキュメントでは、作業ブランチでの改修がプッシュされた際にTestFlightへ自動アップロードされ、実機iPhoneでデバッグできるCI/CD基盤の実装について詳しく説明します。

## 実装内容

### 1. 自動デバッグビルド・TestFlightアップロード機能

#### 対象ブランチ
以下のブランチへのプッシュ時に自動実行されます：
- `feature/**`
- `bugfix/**`  
- `hotfix/**`
- `develop`

#### 主な機能
- **自動ビルド番号生成**: タイムスタンプベース（YYYYMMDDhhmmss）
- **ブランチ識別可能なバージョン名**: `0.1.0-debug-{ブランチ名}`
- **デバッグ版の明示**: アプリ表示名を「Chord Book (Debug)」に変更
- **TestFlightへの自動アップロード**: ビルド完了後、即座にTestFlightに配信
- **PRコメント通知**: PRの場合、ビルド完了をコメントで通知

### 2. ビルド情報管理

#### ビルド番号の仕組み
```
バージョン形式: 0.1.0-debug-{safe_branch}+{build_number}
例: 0.1.0-debug-feature-login-ui+20240914123045
```

- **safe_branch**: ブランチ名を英数字とハイフンのみに変換
- **build_number**: 実行時のタイムスタンプ

#### アーティファクト保存
- ビルド情報（JSON形式）
- IPAファイル
- 保存期間: 30日間

### 3. セキュリティ設定

#### 必要なGitHub Secrets
以下のSecretsを設定する必要があります：

```yaml
# iOS Code Signing
IOS_CERTIFICATE_BASE64          # 配布用証明書（Base64エンコード）
IOS_CERTIFICATE_PASSWORD        # 証明書のパスワード
IOS_PROVISIONING_PROFILE_BASE64 # プロビジョニングプロファイル（Base64エンコード）
KEYCHAIN_PASSWORD               # 一時キーチェーンのパスワード

# App Store Connect API
APP_STORE_CONNECT_API_KEY_ID        # API Key ID
APP_STORE_CONNECT_API_ISSUER_ID     # Issuer ID
APP_STORE_CONNECT_API_KEY_BASE64    # API Key（.p8ファイル、Base64エンコード）
APP_STORE_CONNECT_APP_ID            # App Store Connect上のアプリID
```

### 4. クリーンアップ機能

#### 自動削除のタイミング
- PRがマージされた時
- ブランチが削除された時

#### 削除対象
- TestFlightのデバッグビルド
- GitHub Actionsのアーティファクト
- ブランチ固有のビルド情報

## ファイル構成

### GitHub Actionsワークフロー

```
.github/workflows/
├── debug-build.yml              # デバッグビルド・TestFlightアップロード
└── cleanup-debug-builds.yml     # ビルドクリーンアップ
```

### iOS設定ファイル

```
ios/
└── exportOptions.plist          # IPAエクスポート設定
```

## 利用方法

### 1. 事前準備

#### A. Apple Developer設定
1. **配布用証明書の作成**
   - Apple Developer Centerで「iOS Distribution」証明書を作成
   - `.p12`形式でエクスポート
   - Base64でエンコードしてSecretsに設定

2. **プロビジョニングプロファイルの作成**
   - Bundle ID: `com.yuto.chordbook`
   - Profile名: 「Chord Book Debug Profile」
   - `.mobileprovision`ファイルをBase64エンコードしてSecretsに設定

#### B. App Store Connect API設定
1. **API Keyの作成**
   - App Store Connect > Users and Access > Keys
   - Developer権限でAPI Keyを作成
   - `.p8`ファイルをダウンロードしてBase64エンコード

2. **App IDの確認**
   - App Store ConnectでアプリのIDを確認してSecretsに設定

### 2. 開発フロー

#### デバッグビルドの開始
```bash
# フィーチャーブランチを作成
git checkout -b feature/new-feature

# 変更をプッシュ（自動ビルドが開始される）
git push origin feature/new-feature
```

#### TestFlightでのテスト
1. GitHub Actionsの実行完了を確認
2. TestFlightアプリで「Chord Book (Debug)」を確認
3. デバッグビルドをダウンロード・テスト

#### PRマージ後のクリーンアップ
1. PRをマージ
2. 自動的にクリーンアップワークフローが実行
3. TestFlightからデバッグビルドが削除される

## 技術仕様

### 実行環境
- **Runner**: macOS-14 (GitHub Actions)
- **Xcode**: 15.3
- **Flutter**: 3.24.0（FVMで管理）

### ビルド設定
- **Configuration**: Release
- **Code Signing**: Manual (Distribution証明書使用)
- **Bitcode**: 無効
- **Symbols**: アップロード有効

### パフォーマンス考慮事項
- **並列実行**: ブランチ毎に独立実行
- **キャッシュ利用**: Flutter依存関係とCocoaPodsキャッシュ
- **アーティファクト管理**: 30日間の自動削除

## トラブルシューティング

### よくある問題と解決方法

#### 1. Code Signing エラー
```
Error: No signing certificate "iPhone Distribution" found
```
**解決方法**: 
- 証明書の有効期限を確認
- Base64エンコードが正しいか確認
- 証明書のパスワードが正しいか確認

#### 2. Provisioning Profile エラー
```
Error: No provisioning profile found for bundle identifier
```
**解決方法**:
- Bundle IDが一致しているか確認（`com.yuto.chordbook`）
- プロビジョニングプロファイルの有効期限を確認
- デバイス登録状況を確認

#### 3. TestFlight Upload エラー
```
Error: Unable to upload to App Store Connect
```
**解決方法**:
- API Keyの権限を確認（Developer権限が必要）
- API Key IDとIssuer IDが正しいか確認
- App IDが正しいか確認

#### 4. Build Number 重複エラー
```
Error: Build number already exists
```
**解決方法**:
- タイムスタンプベースなので基本的に発生しない
- 発生した場合は数分後に再実行

## セキュリティ考慮事項

### Secrets管理
- 全ての機密情報はGitHub Secretsで管理
- ワークフロー実行時のみ一時的に利用
- 実行後は自動的にクリーンアップ

### アクセス制御
- GitHub Actionsの実行権限制限
- Apple Developer Teamでの役割ベースアクセス制御
- App Store Connect APIの最小権限原則

### 監査ログ
- GitHub Actionsの実行ログ
- Apple Developer Portalのアクセスログ
- App Store Connectの操作ログ

## 運用・保守

### 定期メンテナンス
- **月次**: 証明書・プロビジョニングプロファイルの有効期限確認
- **四半期**: API Keyのローテーション検討
- **年次**: 証明書の更新

### モニタリング
- GitHub Actionsの実行状況監視
- TestFlightのストレージ使用量監視
- エラー発生時のSlack通知（設定可能）

### バックアップ
- ワークフロー設定のバージョン管理
- 証明書・プロファイルの安全な保管
- 設定ドキュメントの最新化

## 今後の改善案

### 短期的改善
1. **Slack通知機能の追加**
   - ビルド完了・失敗時の通知
   - TestFlightアップロード完了通知

2. **テスト自動実行**
   - ビルド前のユニットテスト実行
   - UIテストの並列実行

### 中長期的改善
1. **マルチプラットフォーム対応**
   - Android版の自動ビルド・配信
   - Firebase App Distributionとの連携

2. **高度な分析機能**
   - ビルド時間の分析・最適化
   - クラッシュレポートとの連携

3. **セキュリティ強化**
   - Secretsの自動ローテーション
   - 署名証明書の自動更新

## 参考資料

### Apple Documentation
- [Xcode Build Settings Reference](https://developer.apple.com/documentation/xcode)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)

### GitHub Actions Documentation
- [GitHub Actions for iOS](https://docs.github.com/en/actions/deployment/deploying-xcode-applications)
- [Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

### Flutter Documentation
- [Building and releasing an iOS app](https://docs.flutter.dev/deployment/ios)
- [Continuous delivery with Flutter](https://docs.flutter.dev/deployment/cd)

---

**実装完了日**: 2024年9月14日  
**バージョン**: 1.0  
**メンテナー**: GitHub Copilot