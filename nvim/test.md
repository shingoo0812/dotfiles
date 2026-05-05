# メインタイトル - レベル1

これは通常のパラグラフです。**太字**、*イタリック*、***太字イタリック***、~~打ち消し線~~などの装飾が使えます。

セクション1 - レベル2

[###](###) サブセクション - レベル3

## レベル4の見出し

## リスト

[###](###) 箇条書きリスト

[-](-) 項目1
- 項目2
  - ネストした項目2-1
  - ネストした項目2-2
    - さらにネスト
- 項目3

### 番号付きリスト

1. 最初の項目
2. 2番目の項目
3. 3番目の項目
   1. ネストした項目
   2. ネストした項目

### チェックボックス（タスクリスト）

- [x] 完了したタスク
- [ ] 未完了のタスク
- [x] 別の完了済みタスク
- [ ] これから行うタスク

## コードブロック

### Pythonコード
```python
def hello_world(name: str) -> str:
    """挨拶を返す関数"""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(hello_world("World"))
```

### Luaコード
```Shell
        sudo mount -t drvfs H: /mnt/h
```
```lua
local function setup()
  require("markview").setup({
    modes = { "n", "no", "c" },
    hybrid_modes = { "i" },
  })
end

return setup()
```

インラインコード

ファイルは `~/.config/nvim/init.lua` に配置し、`:source %` コマンドで読み込みます。
変数は `local variable = "value"` のように定義します。

## 引用

> これは引用ブロックです。
> 複数行にわたって書くこともできます。
>
> > ネストした引用も可能です。
> > これは便利ですね。

## リンク

### 通常のリンク

[Neovim公式サイト](https://neovim.io/)

[markview.nvimリポジトリ](https://github.com/OXY2DEV/markview.nvim)

### 参照スタイルのリンク

[リンクテキスト][ref-id]

[ref-id]: https://example.com "タイトル"

### 自動リンク

<https://github.com>

## テーブル

| 機能 | 説明 | 対応状況 |
|------|------|----------|
| 見出し | H1-H6のレンダリング | ✅ 完全対応 |
| コードブロック | シンタックスハイライト | ✅ 完全対応 |
| テーブル | テーブルの装飾 | ✅ 完全対応 |
| チェックボックス | タスクリスト | ✅ 完全対応 |

### 複雑なテーブル

| Left align | Center align | Right align |
|:-----------|:------------:|------------:|
| 左寄せ | 中央寄せ | 右寄せ |
| データ1 | データ2 | データ3 |
| 長いテキストデータ | 短い | 123 |

## 水平線

---

上と下に水平線があります。

***

別のスタイルの水平線です。

___

## 画像

![代替テキスト](https://via.placeholder.com/150)

## エスケープ

バックスラッシュでエスケープ: \*これはイタリックになりません\*

## 数式（LaTeXが有効な場合）

インライン数式: $E = mc^2$

ブロック数式:

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$

## 脚注

これは脚注の例です[^1]。

別の脚注もあります[^note]。

[^1]: これが脚注の内容です。
[^note]: 名前付き脚注も使えます。

## HTML要素（一部サポート）

<details>
<summary>クリックして展開</summary>

この中身は折りたたまれています。

</details>

<kbd>Ctrl</kbd> + <kbd>C</kbd>

## 複合例

### Houdiniでのノード作成手順

1. **Geometry ノードを作成**
   - Tab メニューから `Geometry` を選択
   - または `/obj` コンテキストで右クリック

2. **内部にノードを追加**
```python
   # Python でノードを作成
   geo = hou.node("/obj").createNode("geo")
   box = geo.createNode("box")
   transform = geo.createNode("xform")
```

3. **パラメータの設定**
   - Size: `1, 1, 1`
   - Center: `0, 0, 0`
   - [ ] Consolidate Points
   - [x] Add Vertex [Normals](Normals)

4. **結果の確認**
   > ビューポートで結果を確認し、必要に応じて調整します。

---

## まとめ

このMarkdownファイルには以下の要素が含まれています:

- ✅ 見出し（H1-H4）
- ✅ リスト（箇条書き、番号付き、チェックボックス）
- ✅ コードブロック（シンタックスハイライト付き）
- ✅ インラインコード
- ✅ 引用ブロック
- ✅ リンク
- ✅ テーブル
- ✅ 水平線
- ✅ テキスト装飾

**markview.nvim** で開くと、これらすべてが美しくレンダリングされます！
