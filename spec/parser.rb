require 'lazri'

describe Lazri do

  before do
    @lazri = Lazri::Parser.new
  end

  describe "parsing newline" do
    it "should be parsed as newline" do
      @lazri.rule(:lf).parse(?\n) == ?\n
    end
  end

end