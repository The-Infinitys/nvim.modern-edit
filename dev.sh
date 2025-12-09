#!/bin/bash

# プラグイン名（ディレクトリ名に合わせて変更）
PLUGIN_NAME="modern-edit"
# テストファイルのパス
TEST_DIR="./tests"

case "$1" in
  # 1. 開発用Neovimの起動
  # カレントディレクトリをruntimepathに追加してNeovimを起動します
  "run")
    nvim --cmd "set rtp+=$(pwd)"
    ;;

  # 2. テストの実行 (plenary.nvimを使用している場合)
  "test")
    nvim --headless -u tests/init.lua \
      -c "PlenaryBustedDirectory $TEST_DIR {minimal_init = 'tests/init.lua'}"
    ;;

  # 3. 構文チェック (lua-language-server や selene が必要)
  "lint")
    if command -v selene > /dev/null; then
      selene lua/
    else
      echo "selene がインストールされていません。"
    fi
    ;;

  # 4. コード整形 (stylua が必要)
  "fmt")
    if command -v stylua > /dev/null; then
      stylua lua/
    else
      echo "stylua がインストールされていません。"
    fi
    ;;

  # 5. ヘルプタグの生成
  "docs")
    nvim --headless -c "helptags doc/" -c "q"
    ;;

  *)
    echo "Usage: ./dev.sh {run|test|lint|fmt|docs}"
    exit 1
    ;;
esac
