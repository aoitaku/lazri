require 'thor'
require_relative 'parser'
require_relative 'transform'

module Lazri
  class CLI < Thor
    desc "json INPUT", "convert into json"
    def json(input)
      src = File.read(input, encoding: "utf-8")
      Lazri.to_json(src)
    end

    desc "text INPUT [transform TRANSFORM=azr]", "convert into text with specified format(default: Aozora)"
    method_option %w{ transform -t } => "azr"
    def azr(input)
      src = File.read(input, encoding: "utf-8")
      case options["ext"]
      when "narou"
        Lazri.to_text(src, "narou")
      when "kakuyomu"
        Lazri.to_text(src, "kakuyomu")
      else
        Lazri.to_text(src)
      end
    end

    desc "html INPUT", "convert into html"
    def html(input)
      src = File.read(input, encoding: "utf-8")
      Lazri.to_html(src)
    end
  end
end
