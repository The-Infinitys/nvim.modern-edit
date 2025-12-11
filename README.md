# nvim.modern-edit

## 概要
`nvim.modern-edit`は、Neovimの編集体験をVS Codeのようなモダンなエディタに近づけるためのプラグインです。特に、InsertモードとVisualモードにおける選択操作や、システムクリップボードとの連携、そしてUndo/Redoの操作性を向上させます。

## 機能

### 1. モダンな選択操作
InsertモードおよびVisualモードにおいて、`Shift` + 矢印キーで直感的にテキストを選択・拡張できます。行をまたぐ選択もスムーズに行えます。

| キーバインド | 説明                 | モード    |
| :----------- | :------------------- | :-------- |
| `<S-Left>`   | 左へ選択範囲を拡張   | Insert/Visual |
| `<S-Right>`  | 右へ選択範囲を拡張   | Insert/Visual |
| `<S-Up>`     | 上へ選択範囲を拡張   | Insert/Visual |
| `<S-Down>`   | 下へ選択範囲を拡張   | Insert/Visual |
| `<C-a>`      | 行全体を選択         | Insert    |

### 2. 強力なクリップボード連携
OSのシステムクリップボード (`+` レジスタ) と連携し、より直感的なコピー＆ペースト、カット操作を提供します。

| キーバインド | 説明                   | モード    |
| :----------- | :--------------------- | :-------- |
| `<C-c>`      | 選択範囲をコピー       | Visual    |
| `<C-x>`      | 選択範囲をカット       | Visual    |
| `<C-v>`      | カーソル位置にペースト | Visual    |
| `<BS>`       | 選択範囲を削除 (カットなし) | Visual    |
| `<Del>`      | 選択範囲を削除 (カットなし) | Visual    |
| `<C-c>`      | 現在の行をコピー       | Insert    |
| `<C-x>`      | 現在の行をカット       | Insert    |
| `<C-v>`      | システムクリップボードの内容を挿入 | Insert |

### 3. 直感的なUndo/Redo
Insertモード中に、簡単に操作の取り消し (Undo) ややり直し (Redo) を行えます。

| キーバインド | 説明       | モード    |
| :----------- | :--------- | :-------- |
| `<C-z>`      | Undo       | Insert    |
| `<C-y>`      | Redo       | Insert    |

## インストール

お好みのプラグインマネージャーを使用してインストールしてください。

### [例: Packer.nvim]
```lua
-- init.lua または plugin.lua
use 'the-infinitys/nvim.modern-edit' -- あなたのリポジトリ名に置き換えてください
```

### [例: dein.vim]
```vim
" .vimrc または dein.toml
call dein#add('the-infinitys/nvim.modern-edit') " あなたのリポジトリ名に置き換えてください
```

## 設定

`init.lua` ファイル内で、プラグインをロードした後、`setup()` 関数を呼び出してください。

```lua
-- init.lua
require('modern-edit').setup()
```

### デフォルト設定

プラグインはデフォルトで以下の`vim.opt`設定を適用します。

```lua
vim.opt.clipboard = "unnamedplus"
vim.opt.whichwrap:append("<,>,[,],b,s")
vim.opt.virtualedit = "onemore"
```

もしこれらの設定を上書きしたい場合は、`setup()` の呼び出し後にご自身の`vim.opt`を設定してください。

## 貢献

バグ報告や機能提案、プルリクエストを歓迎します。

## ライセンス

このプロジェクトは MIT LICENSE の下でライセンスされています。
