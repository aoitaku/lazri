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
