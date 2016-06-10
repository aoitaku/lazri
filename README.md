# Lazri

Lazri は "**L**azri **A**o**z**o**r**a bunko **i**nspired structured text format" の略称です。HTML、json、青空文庫形式、なろう形式、カクヨム形式のテキストに変換可能で、他にも様々なフォーマットへの変換が可能になることを予定しています。もちろん、実装はここにあります！（こめかみを指差す）

## インストール

あなたのアプリケーションの Gemfile に以下の記述を追加します。

```ruby
gem 'lazri'
```

それから次のとおり実行しましょう。

    $ bundle

あるいは、以下の手順で自分でインストールします。

まず `specific_install` gem をインストールします（[https://github.com/rdp/specific_install](https://github.com/rdp/specific_install)を参照してください）。

それから以下を実行します。

    $ gem specific_install aoitaku/lazri

これでインストール完了です。

## 使い方

以下のコマンドを実行します。

    $ lazri j example.lazr

`.lazr` ファイルが `.json` ファイルに変換されます。

## 語源

Lazri の名前は lapis lazuli に含まれる青金石（lazurite）と、ラズ人の言語であるラズ語（lazuri nena）に由来します。

Lazri の仕様は青空文庫のアノテーションを参考に「そこそこヒューマンライタブル、まずまずマシンパーサブル™」な構造化テキストフォーマットを目指して作られました。青空にちなんだ名前として azur を含み、かつ言語に関係する名前であることから、lazuri が採用されました。

lazuri というコーカサス地方に一般的な名称と衝突するのを回避するため、また、"**L**azri **A**o**z**o**r**a bunko **i**nspired structured text format" という [バクロニム](https://ja.wikipedia.org/wiki/%E3%83%90%E3%82%AF%E3%83%AD%E3%83%8B%E3%83%A0) を構成することができるように、途中の u を脱落させています。
