require 'lazri'
require 'parslet/convenience'

describe Lazri, 'parser' do

  let(:lazri) do
    Lazri::Parser.new
  end

  describe 'in inline context' do

    let (:inline_context) do
      lazri.inline_nodes
    end

    it 'parses "^TEXT(RUBY)"" as a rubified text' do
      result = inline_context.parse_with_debug('^漢字(よみがな)')
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
      result = inline_context.parse_with_debug('``あいうえお``')
      expect(result).to match [
        { bouten: 'あいうえお' }
      ]
    end

    it 'parses "PLAIN TEXT" as a text' do
      result = inline_context.parse_with_debug('あいうえお')
      expect(result).to match [
        { text: 'あいうえお' }
      ]
    end

    it 'parses mixed text as each format separately' do
      result = inline_context.parse_with_debug('あいうえお^漢字(よみがな)``かきくけこ``さしすせそ')
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

    let(:block_element_context) do
      lazri.block_element
    end

    it 'parses "====== TITLE" as title' do
      result = block_element_context.parse_with_debug('====== TITLE')
      expect(result).to match title: [
        { text: 'TITLE' }
      ]
    end

    it 'parses "====== TITLE ======" as title' do
      result = block_element_context.parse_with_debug('====== TITLE ======')
      expect(result).to match title: [
        { text: 'TITLE' }
      ]
    end

    it 'parses "==== HEADING" as heading' do
      result = block_element_context.parse_with_debug('==== HEADING')
      expect(result).to match heading: [
        { text: 'HEADING' }
      ]
    end

    it 'parses "==== HEADING ====" as heading' do
      result = block_element_context.parse_with_debug('==== HEADING ====')
      expect(result).to match heading: [
        { text: 'HEADING' }
      ]
    end

    it 'parses "== SUBHEADING" as subheading' do
      result = block_element_context.parse_with_debug('== SUBHEADING')
      expect(result).to match subheading: [
        { text: 'SUBHEADING' }
      ]
    end

    it 'parses "== SUBHEADING ==" as subheading' do
      result = block_element_context.parse_with_debug('== SUBHEADING ==')
      expect(result).to match subheading: [
        { text: 'SUBHEADING' }
      ]
    end

    it 'parses "***" as ruler' do
      result = block_element_context.parse_with_debug('***')
      expect(result).to match ruler: '***'
    end

    it 'parses "- TEXT" as list' do
      result = block_element_context.parse_with_debug('- TEXT')
      expect(result).to match bulleted_list: [
        { item: { text: 'TEXT'} }
      ]
    end
        it 'parses nested bulleted list as expected' do
      result = block_element_context.parse_with_debug("- TEXT\n  - TEXT")
      expect(result).to match bulleted_list: [
        { item: {
            text: 'TEXT',
            children: {
              bulleted_list: [
                { item: { text: 'TEXT' } }
              ]
            }
          }
        }
      ]
    end

    it 'parses "1) TEXT" as numbered list' do
      result = block_element_context.parse_with_debug('1) TEXT')
      expect(result).to match numbered: [
        { text: 'TEXT'}
      ]
    end
  end

  describe 'in document context' do

    let(:undent) do
      -> str { str.each_line.map{|_|_.gsub(/^ +/,'')}.join }
    end

    it 'parses paragraphs separated by blank line as several clauses' do
      result = lazri.parse undent.(<<-EOF)
        文章

        文章文章文章
        文章

        文章文章文章
        文章

        文章文章文章
      EOF
      expect(result).to match [
        { section: [
          { clause: [{ paragraph: [{ text: '文章' }] }] },
          { clause: [
            { paragraph: [{ text: '文章文章文章' }] },
            { paragraph: [{ text: '文章' }] }
          ]},
          { clause: [
            { paragraph: [{ text: '文章文章文章' }] },
            { paragraph: [{ text: '文章' }] }
          ]},
          { clause: [{ paragraph: [{ text: '文章文章文章' }] }] }
        ]}
      ]
    end

    it 'parses paragraphs separated by several blank lines as several sections' do
      result = lazri.parse undent.(<<-EOF)
        文章
        文章文章文章
        文章


        文章文章文章
        文章
        文章文章文章


        文章
        文章文章文章
        文章
      EOF
      expect(result).to match [
        { section: [
          { clause: [
            { paragraph: [{ text: '文章' }] },
            { paragraph: [{ text: '文章文章文章' }] },
            { paragraph: [{ text: '文章' }] }
          ]}
        ]},
        { section: [
          { clause: [
            { paragraph: [{ text: '文章文章文章' }] },
            { paragraph: [{ text: '文章' }] },
            { paragraph: [{ text: '文章文章文章' }] }
          ]}
        ]},
        { section: [
          { clause: [
            { paragraph: [{ text: '文章' }] },
            { paragraph: [{ text: '文章文章文章' }] },
            { paragraph: [{ text: '文章' }] }
          ]}
        ]}
      ]
    end

    it 'parses document as each section, clause and paragraph separately' do
      result = lazri.parse undent.(<<-EOF)
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