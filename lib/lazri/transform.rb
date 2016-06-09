require 'json'

module Lazri

  def self.to_json(src)
    JSON.dump(Parser.new.parse(src))
  end

end
