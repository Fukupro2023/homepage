# homepage

福プロのホームページのリポジトリです。

- `astro/` … フロントエンド（Astro）
- `cms/` … 管理用 CMS（Rails + PostgreSQL、Docker コンテナ）

---

## 起動方法

### Astro フロント

```bash
cd astro
pnpm install
pnpm dev
```

ブラウザで `http://localhost:4321` にアクセス。

### CMS（Rails + PostgreSQL, Docker）

#### 初期設定
`.env.example` をコピーして `.env` を作成し、必要な環境変数を設定してください。
`RAILS_MASTER_KEY` は `cms/config/master.key` の内容をメンバーから共有してもらって設定してください。

```bash
cd cms
bundle install
docker compose up --build
```
ブラウザで `http://localhost:3000` にアクセス
