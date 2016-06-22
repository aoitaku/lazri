require 'lazri'
require 'lazri/transform/narou'

describe Lazri, 'narou transform' do

  def undented(str)
    str.each_line.map{|_|_.gsub(/^ +/,'')}.join
  end

  let(:document) do
    undented <<-EOF
      ====== 大見出し ======

      文章
      文章文章


      文章文章

      ==== 中見出し ====

      文章文章

      == 小見出し ==

      文章

      文章``文章``文章

      ***

      文章文章
      文章^文章(ぶんしょう)文章

      == 小見出し ==

      文章文章
    EOF
  end

  let(:expected) do
    undented <<-EOF


      　　　　　　大見出し


      文章
      文章文章


      文章文章



      　　　　中見出し


      文章文章


      　　小見出し

      文章

      文章｜文《・》｜章《・》文章


      　　＊＊＊


      文章文章
      文章｜文章《ぶんしょう》文章


      　　小見出し

      文章文章


    EOF
  end

  it "converts document into narou formatted text" do
    result = Lazri.to_text(document, format: :narou)
    expect(result).to eq expected
  end

end
