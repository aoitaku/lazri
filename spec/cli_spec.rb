require 'lazri'

describe Lazri, 'CLI' do

  before do
    @cli = Lazri::CLI.new
  end

  let(:example_lazr) do <<-EOF.each_line.map{|str| str.gsub(/^ +/, '')}.join end
    ====== 大見出し ======

    文章
    文章文章


    文章文章

    ==== 中見出し ====

    文章文章

    == 小見出し ==

    文章

    文章文章文章

    ***

    文章文章
    文章文章文章

    == 小見出し ==

    文章文章
  EOF

  let(:example_json) do
    JSON.dump([
      { title: [{ text: '大見出し' }] },
      { section: [
        { clause: [
          { paragraph: [{ text: '文章' }] },
          { paragraph: [{ text: '文章文章' }] }
        ]}
      ]},
      { section: [{ clause: [{ paragraph: [{ text: '文章文章' }] }] }] },
      { heading: [{ text: '中見出し' }] },
      { section: [{ clause: [{ paragraph: [{ text: '文章文章' }] }] }] },
      { subheading: [{ text: '小見出し' }] },
      { section: [
        { clause: [{ paragraph: [{ text: '文章' }] }] },
        { clause: [{ paragraph: [{ text: '文章文章文章' }] }] }
      ]},
      { ruler: '***' },
      { section: [
        { clause: [
          { paragraph: [{ text: '文章文章' }] },
          { paragraph: [{ text: '文章文章文章' }] }
        ]}
      ]},
      { subheading: [{ text: '小見出し' }] },
      { section: [{ clause: [{ paragraph: [{ text: '文章文章' }] }] }] }
    ])
  end

  it 'is given j for option then converts input into output with json format' do
    src = "#{__dir__}/../sandbox/example.lazr"
    dest = "#{__dir__}/../sandbox/example.json"

    allow(File).to receive(:read).with(src, encoding: 'utf-8').and_return(example_lazr)
    allow(File).to receive(:write) do |path, json|
      expect(path).to eq dest
      expect(json).to eq example_json
    end

    result = @cli.invoke(:json, [src])
    expect(result).to eq 'done.'
  end
end
