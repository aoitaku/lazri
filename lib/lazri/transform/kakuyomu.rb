module Lazri

  module Kakuyomu

    class Transform < Parslet::Transform

      rule(text: simple(:text)) do
        text.to_s
      end

      rule(bouten: simple(:text)) do
        "《《#{text.to_s}》》"
      end

      rule(rubi: { rubi_base: simple(:rubi_base), rubi_text: simple(:rubi_text) }) do
        "｜#{rubi_base.to_s}《#{rubi_text.to_s}》"
      end

      rule(sequence(:nodes)) do
        nodes.join
      end

      rule(paragraph: simple(:nodeset)) do
        nodeset + ?\n
      end

      rule(clause: simple(:nodeset)) do
        nodeset + ?\n
      end

      rule(section: simple(:nodeset)) do
        nodeset + ?\n
      end

      rule(title: simple(:nodeset)) do
        ?\n + ?\n +
        "　　　　　　" + nodeset +
        ?\n + ?\n + ?\n
      end

      rule(heading: simple(:nodeset)) do
        ?\n +
        "　　　　" + nodeset +
        ?\n + ?\n + ?\n
      end

      rule(subheading: simple(:nodeset)) do
        "　　" + nodeset +
        ?\n + ?\n

      end

      rule(ruler: simple(:text)) do
        "　　＊＊＊" +
        ?\n + ?\n + ?\n
      end

    end

    def self.to_text(src)
      transform = Lazri::Kakuyomu::Transform.new
      transform.apply(src)
    end

  end
end
