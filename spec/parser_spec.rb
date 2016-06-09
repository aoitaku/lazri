require 'lazri'

describe Lazri, 'parser' do

  before do
    @lazri = Lazri::Parser.new
  end

  describe 'in inline context' do

    before do
      @inline_context = @lazri.inline_nodes
    end

    it 'parses "^TEXT(RUBY)"" as a rubified text' do
      result = @inline_context.parse('^漢字(よみがな)')
      expect(result).to match [
        {
          rubi: {
            rubi_base: '漢字',
            rubi_text: 'よみがな'
          }
        }
      ]
    end

    it 'parses "``BOUTEN TEXT``"" as a text with bouten' do
      result = @inline_context.parse('``あいうえお``')
      expect(result).to match [
        { bouten: 'あいうえお' }
      ]
    end

    it 'parses "PLAIN TEXT" as a text' do
      result = @inline_context.parse('あいうえお')
      expect(result).to match [
        { text: 'あいうえお' }
      ]
    end

    it 'parses mixed text as each format separately' do
      result = @inline_context.parse('あいうえお^漢字(よみがな)``かきくけこ``さしすせそ')
      expect(result).to match [
        { text: 'あいうえお' },
        {
          rubi: {
            rubi_base: '漢字',
            rubi_text: 'よみがな'
          }
        },
        { bouten: 'かきくけこ' },
        { text: 'さしすせそ' }
      ]
    end

  end

  describe 'in block element context' do

    before do
      @block_element_context = @lazri.block_element
    end

    it 'parses "====== TITLE" as title' do
      result = @block_element_context.parse('====== TITLE')
      expect(result).to match title: [
        { text: 'TITLE' }
      ]
    end

    it 'parses "====== TITLE ======" as title' do
      result = @block_element_context.parse('====== TITLE ======')
      expect(result).to match title: [
        { text: 'TITLE' }
      ]
    end

    it 'parses "==== HEADING" as heading' do
      result = @block_element_context.parse('==== HEADING')
      expect(result).to match heading: [
        { text: 'HEADING' }
      ]
    end

    it 'parses "==== HEADING ====" as heading' do
      result = @block_element_context.parse('==== HEADING ====')
      expect(result).to match heading: [
        { text: 'HEADING' }
      ]
    end

    it 'parses "== SUBHEADING" as subheading' do
      result = @block_element_context.parse('== SUBHEADING')
      expect(result).to match subheading: [
        { text: 'SUBHEADING' }
      ]
    end

    it 'parses "== SUBHEADING ==" as subheading' do
      result = @block_element_context.parse('== SUBHEADING ==')
      expect(result).to match subheading: [
        { text: 'SUBHEADING' }
      ]
    end

    it 'parses "***" as ruler' do
      result = @block_element_context.parse('***')
      expect(result).to match ruler: '***'
    end

  end

  describe 'in document context' do


    it 'parses sentenses as each section, clause and paragraph separately' do
      result = @lazri.parse <<-EOF.each_line.map{|str| str.gsub(/^ +/, '')}.join
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
      expect(result).to match [
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
      ]
    end
  end

end