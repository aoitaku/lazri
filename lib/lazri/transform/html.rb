require 'oga'

module Lazri

  module HTML

    def self.document
      Oga::XML::Document.new(type: :html)
    end

    class Builder

      def text(text)
        Oga::XML::Text.new(text: text)
      end

      def attribute(option)
        Oga::XML::Attribute.new(option)
      end

      def element(option)
        Oga::XML::Element.new(option)
      end

      def nodeset(*nodes)
        Oga::XML::NodeSet.new(nodes)
      end

    end

    class Transform < Parslet::Transform

      def apply(src, *)
        super(src, html: HTML::Builder.new)
      end

      rule(text: simple(:text)) do
        html.text(text.to_s)
      end

      rule(bouten: simple(:text)) do
        html.element(name: 'b', children: html.nodeset(html.text(text.to_s)), attributes: [html.attribute(name: 'class', value: 'bouten')])
      end

      rule(rubi: { rubi_base: simple(:rubi_base), rubi_text: simple(:rubi_text) }) do
        html.element(name: 'ruby', children: html.nodeset(
          html.element(name: 'rb', children: html.nodeset(html.text(rubi_base.to_s))),
          html.element(name: 'rp', children: html.nodeset(html.text('（'))),
          html.element(name: 'rt', children: html.nodeset(html.text(rubi_text.to_s))),
          html.element(name: 'rp', children: html.nodeset(html.text('）')))
        ))
      end

      rule(sequence(:nodes)) do
        html.nodeset(*nodes)
      end

      rule(paragraph: simple(:nodeset)) do
        html.element(name: 'p', children: nodeset)
      end

      rule(clause: simple(:nodeset)) do
        html.element(name: 'div', children: nodeset)
      end

      rule(section: simple(:nodeset)) do
        html.element(name: 'section', children: nodeset)
      end

      rule(title: simple(:nodeset)) do
        html.element(name: 'h1', children: nodeset)
      end

      rule(heading: simple(:nodeset)) do
        html.element(name: 'h2', children: nodeset)
      end

      rule(subheading: simple(:nodeset)) do
        html.element(name: 'h3', children: nodeset)
      end

      rule(ruler: simple(:text)) do
        html.element(name: 'hr', attributes: [html.attribute(name: 'title', value: text.to_s)])
      end

    end
  end

  def self.to_html(src)
    transform = HTML::Transform.new
    parser = Lazri::Parser.new
    doc = HTML.document
    doc.children = transform.apply(parser.parse(src))
    doc.to_xml
  end

end
