# デバッグ用CI/CD基盤 - 実装完了レポート

## 実装概要

Chord Bookプロジェクト用のデバッグCI/CD基盤を構築しました。これにより、作業ブランチ（feature/*、bugfix/*、hotfix/*、develop）へのプッシュ時に自動的にTestFlightにデバッグビルドがアップロードされ、実機iPhoneでのテストが可能になります。

## 実装したファイル一覧

### 1. GitHub Actions ワークフロー

#### `.github/workflows/debug-build.yml`
- **機能**: デバッグビルドの自動生成とTestFlightアップロード
- **トリガー**: 
  - 作業ブランチへのプッシュ
  - PRの作成・更新
  - 手動実行
- **主な処理**:
  - Flutter環境のセットアップ
  - iOSコード署名の設定
  - ブランチ固有のビルド番号生成
  - IPAファイルの生成と署名
  - TestFlightへのアップロード
  - ビルド完了通知

#### `.github/workflows/cleanup-debug-builds.yml`
- **機能**: PRマージ後のデバッグビルド自動削除
- **トリガー**: 
  - PRのマージ
  - ブランチの削除
- **主な処理**:
  - TestFlightからの該当デバッグビルド削除
  - GitHub Actionsアーティファクトの削除
  - クリーンアップ完了通知

#### `.github/workflows/validate-setup.yml`
- **機能**: CI/CD環境の設定検証
- **トリガー**: 手動実行、ワークフロー変更時
- **主な処理**:
  - 必要ファイルの存在確認
  - Flutter/iOS環境の検証
  - プロジェクト構成の妥当性確認

### 2. iOS設定ファイル

#### `ios/exportOptions.plist`
- IPAファイルエクスポート用の設定
- App Store配信用の設定を定義
- Manual Signingの設定

### 3. ドキュメント

#### `CI_CD_DEBUG_IMPLEMENTATION.md`
- 実装の詳細仕様書（日本語）
- アーキテクチャの説明
- セキュリティ考慮事項
- 運用保守ガイド

#### `SETUP_GUIDE.md`
- セットアップ手順書（日本語）
- 必要なSecrets設定方法
- トラブルシューティングガイド
- セキュリティベストプラクティス

### 4. プロジェクト設定更新

#### `.gitignore`
- CI/CD関連の一時ファイル除外設定追加
- セキュリティファイル（証明書、APIキー等）の除外
- ビルドアーティファクトの除外

## 主な特徴

### 🔐 セキュリティ
- 全ての機密情報はGitHub Secretsで管理
- 一時キーチェーンを使用した安全な署名
- ビルド後の自動クリーンアップ

### 🏷️ ビルド管理
- タイムスタンプベースの一意なビルド番号
- ブランチ名を含むバージョン識別
- デバッグ版の明示的な表示名

### 🚀 自動化
- プッシュ時の自動ビルド・アップロード
- PRマージ後の自動クリーンアップ
- 各段階での通知機能

### 📱 TestFlight連携
- App Store Connect API経由でのアップロード
- デバッグビルドの自動配信
- テスター向けの実機テスト環境

## ブランチ戦略とビルド番号例

### 対象ブランチ
```
feature/login-ui        → 0.1.0-debug-feature-login-ui+20240914123045
bugfix/metronome-crash  → 0.1.0-debug-bugfix-metronome-crash+20240914123156
hotfix/security-patch   → 0.1.0-debug-hotfix-security-patch+20240914123267
develop                 → 0.1.0-debug-develop+20240914123378
```

### TestFlightでの表示
- アプリ名: **Chord Book (Debug)**
- バージョン識別が容易
- 本番版との明確な区別

## 必要な設定

### GitHub Secrets（8個）
1. `IOS_CERTIFICATE_BASE64` - iOS配布用証明書
2. `IOS_CERTIFICATE_PASSWORD` - 証明書パスワード
3. `IOS_PROVISIONING_PROFILE_BASE64` - プロビジョニングプロファイル
4. `APP_STORE_CONNECT_API_KEY_ID` - App Store Connect API Key ID
5. `APP_STORE_CONNECT_API_ISSUER_ID` - API Issuer ID
6. `APP_STORE_CONNECT_API_KEY_BASE64` - API Key (.p8ファイル)
7. `APP_STORE_CONNECT_APP_ID` - アプリの App Store Connect ID
8. `KEYCHAIN_PASSWORD` - 一時キーチェーンパスワード

### Apple Developer設定
- Bundle ID: `com.yuto.chordbook`
- Development Team: `M38VA3QPJR`
- Distribution証明書の作成
- プロビジョニングプロファイル「Chord Book Debug Profile」の作成

## 利用開始手順

### 1. 事前準備
```bash
# セットアップガイドを確認
cat SETUP_GUIDE.md

# 設定検証ワークフローを実行
# GitHub Actions > Validate CI/CD Setup > Run workflow
```

### 2. 初回テスト
```bash
# フィーチャーブランチを作成
git checkout -b feature/test-debug-build

# 変更をプッシュ（自動ビルドが開始される）
git push origin feature/test-debug-build
```

### 3. TestFlightで確認
1. GitHub Actionsの実行完了を待つ
2. TestFlightアプリで「Chord Book (Debug)」を確認
3. デバッグビルドをダウンロード・テスト

## 運用フロー

### 開発者の操作
1. **作業ブランチ作成**: `git checkout -b feature/new-feature`
2. **コード変更・プッシュ**: `git push origin feature/new-feature`
3. **自動ビルド開始**: GitHub Actionsが自動実行
4. **TestFlightでテスト**: デバッグ版で動作確認
5. **PRマージ**: `git merge` でメインブランチにマージ
6. **自動クリーンアップ**: デバッグビルドが自動削除

### 自動化される処理
- ✅ ビルド番号の生成
- ✅ iOSアプリのビルド・署名
- ✅ TestFlightへのアップロード
- ✅ PRコメントでの通知
- ✅ マージ後のクリーンアップ
- ✅ アーティファクトの管理

## 期待効果

### 開発効率の向上
- **実機テストの迅速化**: プッシュから数分でTestFlightに配信
- **ビルド環境の統一**: GitHub Actions上での一貫したビルド
- **手動作業の削減**: ビルド・アップロード・クリーンアップの自動化

### 品質管理の強化
- **早期の不具合発見**: 実機での継続的なテスト
- **ブランチ単位のテスト**: 機能毎の独立した検証
- **バージョン管理**: 明確なビルド識別

### チーム協業の改善
- **テスト共有**: TestFlightでのチーム内テスト
- **進捗可視化**: PRコメントでの状況共有
- **環境管理**: デバッグ版の自動クリーンアップ

## 今後の拡張案

### 短期的改善
- Slack/Discord通知の追加
- テストの自動実行
- ビルド時間の最適化

### 中長期的改善
- Android版CI/CDの構築
- 本番リリース自動化
- パフォーマンス監視連携

---

**実装完了**: 2024年9月14日  
**対応Issue**: #3  
**実装者**: GitHub Copilot

このCI/CD基盤により、Chord Bookプロジェクトの開発効率と品質が大幅に向上することが期待されます。