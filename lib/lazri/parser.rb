require 'parslet'

module Lazri

  class Parser < Parslet::Parser

    rule(:lf)  { str(?\n) }
    rule(:sp)  { str(?\s) }
    rule(:eof) { any.absent? }

    rule(:line_ending) do
      lf |
      eof
    end

    rule(:bouten) do
      str("``") >>
      match[%/^`\n/].repeat(1).as(:bouten) >>
      str("``")
    end

    rule(:rubi) do
      str(?^) >>
      match[%/^(\n/].repeat(1).as(:rubi_base) >>
      str(?() >>
      match[%/^)\n/].repeat(1).as(:rubi_text) >>
      str(?))
    end

    rule(:inline_element) do
      bouten |
      rubi.as(:rubi)
    end

    rule(:char) do
      (inline_element | lf).absent? >>
      any
    end

    rule(:text) do
      char.repeat(1)
    end

    rule(:inline_node) do
      inline_element |
      text.as(:text)
    end

    rule(:inline_nodes) do
      inline_node.repeat(1)
    end

    rule(:blank_line) do
      lf.repeat(1)
    end

    rule(:ruler) do
      lf.absent? >>
      str("***").as(:ruler) >>
      line_ending
    end

    rule(:header_containable_char) do
      (inline_element | header_suffix | lf).absent? >>
      any
    end

    rule(:header_containable_text) do |variable|
      header_containable_char.repeat(1)
    end

    rule(:header_containable) do
      inline_element |
      header_containable_text.as(:text)
    end

    rule(:header_containables) do
      header_containable.repeat(1)
    end

    rule(:header_suffix) do
      lf.absent? >>
      sp.repeat(1) >>
      str(?=).repeat(2) >>
      line_ending
    end

    rule(:header_ending) do
      header_suffix |
      line_ending
    end

    rule(:title_prefix) do
      lf.absent? >>
      str("==" * 3) >>
      sp.repeat(1)
    end

    rule(:title) do
      title_prefix >>
      header_containables.as(:title) >>
      header_ending
    end

    rule(:heading_prefix) do
      lf.absent? >>
      str("==" * 2) >>
      sp.repeat(1)
    end

    rule(:heading) do
      heading_prefix >>
      header_containables.as(:heading) >>
      header_ending
    end

    rule(:subheading_prefix) do
      lf.absent? >>
      str("==") >>
      sp.repeat(1)
    end

    rule(:subheading) do
      subheading_prefix >>
      header_containables.as(:subheading) >>
      header_ending
    end

    rule(:header) do
      title |
      heading |
      subheading
    end

    def indent(depth)
      str(?\s * depth * 2)
    end

    def bulleted_item(depth)
      lf.absent? >>
      indent(depth) >>
      str(?-) >>
      sp >>
      text.as(:text) >>
      line_ending
    end

    rule(:numbering_marker) do
      match['\d'].repeat(1)  |
      match['a-z'].repeat(1) |
      match['A-Z'].repeat(1)
    end

    def numbered_item(depth)
      lf.absent? >>
      indent(depth) >>
      numbering_marker >>
      str(?)) >>
      sp >>
      text.as(:text) >>
      line_ending
    end

    def bulleted_list(lv)
      (
        bulleted_item(lv) >>
        dynamic {|*| list(lv+1) }.as(:children).maybe
      ).as(:item).repeat(1)
    end

    def numbered_list(lv)
      (
        numbered_item(lv) >>
        dynamic {|*| list(lv+1) }.as(:children).maybe
      ).as(:item).repeat(1)
    end

    def list(lv)
      bulleted_list(lv).as(:bulleted_list) |
      numbered_list(lv).as(:numbered_list)
    end

    rule(:block_element) do
      ruler  |
      header |
      list(0)
    end

    rule(:paragraph) do
      (block_element | lf).absent? >>
      inline_nodes.as(:paragraph) >>
      line_ending
    end

    rule(:clause) do
      paragraph.repeat(1).as(:clause)
    end

    rule(:section) do
      (clause >> lf.maybe).repeat(1).as(:section)
    end

    rule(:block_node) do
      blank_line |
      block_element |
      section
    end

    rule(:doc) do
      block_node.repeat
    end

    root :doc
  end
end
