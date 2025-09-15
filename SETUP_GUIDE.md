# デバッグ用CI/CD セットアップガイド

このガイドでは、デバッグ用CI/CD基盤を利用するために必要な設定手順を説明します。

## 必要なGitHub Secretsの設定

### 1. Apple Developer関連の設定

#### A. iOS Distribution証明書の準備

1. **Apple Developer Centerにアクセス**
   - https://developer.apple.com/account/
   - Certificates, Identifiers & Profiles > Certificates

2. **Distribution証明書の作成・ダウンロード**
   ```bash
   # 証明書をキーチェーンからp12形式でエクスポート
   # パスワードを設定してエクスポート
   
   # Base64エンコード
   base64 -i certificate.p12 -o certificate_base64.txt
   ```

3. **GitHub Secretsに設定**
   - `IOS_CERTIFICATE_BASE64`: certificate_base64.txtの内容
   - `IOS_CERTIFICATE_PASSWORD`: エクスポート時に設定したパスワード

#### B. プロビジョニングプロファイルの準備

1. **App IDの確認・作成**
   - Bundle ID: `com.yuto.chordbook`
   - Services: 必要なサービスを有効化

2. **プロビジョニングプロファイルの作成**
   - Type: App Store
   - App ID: com.yuto.chordbook
   - Certificates: 上記で作成したDistribution証明書を選択
   - Profile Name: "Chord Book Debug Profile"

3. **GitHub Secretsに設定**
   ```bash
   # mobileprovisionファイルをBase64エンコード
   base64 -i profile.mobileprovision -o profile_base64.txt
   ```
   - `IOS_PROVISIONING_PROFILE_BASE64`: profile_base64.txtの内容

### 2. App Store Connect API設定

#### A. API Keyの作成

1. **App Store Connectにアクセス**
   - https://appstoreconnect.apple.com/
   - Users and Access > Keys

2. **API Keyの作成**
   - Access: Developer
   - Name: "Chord Book CI/CD"
   - Download the .p8 file

3. **GitHub Secretsに設定**
   ```bash
   # p8ファイルをBase64エンコード
   base64 -i AuthKey_XXXXXXXXXX.p8 -o api_key_base64.txt
   ```
   - `APP_STORE_CONNECT_API_KEY_ID`: Key ID (例: 2X9R4HXF34)
   - `APP_STORE_CONNECT_API_ISSUER_ID`: Issuer ID (例: 57246542-96fe-1a63-e053-0824d011072a)
   - `APP_STORE_CONNECT_API_KEY_BASE64`: api_key_base64.txtの内容

#### B. App IDの確認

1. **App Store Connectでアプリを確認**
   - Apps > Chord Book > App Information
   - Apple ID をコピー

2. **GitHub Secretsに設定**
   - `APP_STORE_CONNECT_APP_ID`: Apple ID (例: 1234567890)

### 3. その他の設定

#### Keychain Password
- `KEYCHAIN_PASSWORD`: 任意の強力なパスワード（20文字以上推奨）

## セットアップ確認リスト

### 事前準備
- [ ] Apple Developer Program登録済み
- [ ] App Store Connectでアプリ作成済み  
- [ ] 実機デバイスの開発者登録済み
- [ ] TestFlightのテストユーザー登録済み

### GitHub Secrets設定
- [ ] `IOS_CERTIFICATE_BASE64`
- [ ] `IOS_CERTIFICATE_PASSWORD`
- [ ] `IOS_PROVISIONING_PROFILE_BASE64`
- [ ] `APP_STORE_CONNECT_API_KEY_ID`
- [ ] `APP_STORE_CONNECT_API_ISSUER_ID`
- [ ] `APP_STORE_CONNECT_API_KEY_BASE64`
- [ ] `APP_STORE_CONNECT_APP_ID`
- [ ] `KEYCHAIN_PASSWORD`

### 動作確認
- [ ] フィーチャーブランチでプッシュテスト
- [ ] GitHub Actionsの実行確認
- [ ] TestFlightでのビルド確認
- [ ] 実機でのダウンロード・起動確認

## トラブルシューティング

### 設定確認コマンド

```bash
# GitHub Secretsの確認（値は表示されませんが設定済みかわかります）
gh secret list

# 証明書の有効期限確認
security find-certificate -c "iPhone Distribution" -p | openssl x509 -noout -dates

# プロビジョニングプロファイルの確認
security cms -D -i profile.mobileprovision
```

### よくあるエラー

#### 1. "No signing certificate found"
- 証明書の有効期限を確認
- Team IDが正しいか確認
- Base64エンコードが正しいか確認

#### 2. "Invalid provisioning profile"
- Bundle IDが一致しているか確認
- プロファイルの有効期限確認
- デバイスが登録されているか確認

#### 3. "App Store Connect authentication failed"
- API Key IDとIssuer IDが正しいか確認
- API Keyの権限が Developer になっているか確認
- App IDが正しいか確認

## セキュリティベストプラクティス

### Secrets管理
1. **定期的な更新**
   - 証明書: 年1回
   - API Key: 四半期ごと検討
   - パスワード: 月1回

2. **アクセス制限**
   - 必要最小限の権限のみ付与
   - 利用者の定期的な見直し

3. **ログ監視**
   - GitHub Actionsの実行ログ確認
   - 異常なアクセスパターンの監視

### バックアップ
1. **証明書・プロファイル**
   - 安全な場所への暗号化保存
   - 複数名でのアクセス可能性確保

2. **設定情報**
   - Secrets設定の文書化
   - 設定手順書の最新化

## 運用開始後の監視項目

### 日次確認
- [ ] GitHub Actionsの実行状況
- [ ] エラー発生の有無
- [ ] TestFlightのストレージ使用量

### 週次確認
- [ ] ビルド成功率の確認
- [ ] 平均ビルド時間の監視
- [ ] 累積アーティファクトサイズ

### 月次確認
- [ ] 証明書の有効期限チェック
- [ ] プロビジョニングプロファイルの有効期限チェック
- [ ] API使用量の確認
- [ ] セキュリティログの確認

---

設定でご不明な点がございましたら、このリポジトリのIssueでお気軽にお尋ねください。