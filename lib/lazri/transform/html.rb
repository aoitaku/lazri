module Lazri

  class HTMLTransform < Parslet::Transform

    rule(text: simple(:x)) do
      x
    end

    rule(text: simple(:x)) do
      x
    end

    rule(heading: sequence(:x)) do
      x.join
    end

    rule(subheading: sequence(:x)) do
      x.join
    end

    rule(title: sequence(:x)) do
      x.join
    end

    rule(ruler: simple(:ruler)) do
      ruler
    end

  end
end
