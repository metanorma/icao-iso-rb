module Atmospheric
  module Export
    module Iso25331975
      class << self
        def table_5
          GroupOne.new.to_h
        end

        def table_6
          GroupTwo.new.to_h
        end

        def table_7
          GroupThree.new.to_h
        end

        def table_5_yaml
          GroupOne.new.set_attrs.to_yaml
        end

        def table_6_yaml
          GroupTwo.new.set_attrs.to_yaml
        end

        def table_7_yaml
          GroupThree.new.set_attrs.to_yaml
        end
      end
    end
  end
end

require_relative "iso_25331975/group_base"
require_relative "iso_25331975/group_one"
require_relative "iso_25331975/group_two"
require_relative "iso_25331975/group_three"
