require 'lazri'
require 'lazri/transform/html'

describe Lazri, 'HTML transform' do

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

  let(:expected_html) do
    Oga.parse_html(%w[
      <h1>大見出し</h1>
      <section><div><p>文章</p><p>文章文章</p></div></section>
      <section><div><p>文章文章</p></div></section>
      <h2>中見出し</h2>
      <section><div><p>文章文章</p></div></section>
      <h3>小見出し</h3>
      <section><div><p>文章</p></div><div><p>文章<b\ class="bouten">文章</b>文章</p></div></section>
      <hr\ title="***">
      <section><div><p>文章文章</p><p>文章<ruby><rb>文章</rb><rp>（</rp><rt>ぶんしょう</rt><rp>）</rp></ruby>文章</p></div></section>
      <h3>小見出し</h3>
      <section><div><p>文章文章</p></div></section>
    ].join).to_xml
  end

  it "converts document into html" do
    result = Lazri.to_html(document)
    expect(result).to eq expected_html
  end

end
