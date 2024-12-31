require_relative "./target"
require_relative "./iso_25331975"

module Atmospheric
  module Export
    module Iso25331997
      module GroupBaseMeters
        def steps
          (-5000..2000).step(50)
        end
      end

      class GroupOne < Iso25331975::GroupOne
        include Iso25331997::GroupBaseMeters
      end

      class GroupTwo < Iso25331975::GroupTwo
        include Iso25331997::GroupBaseMeters
      end

      class GroupThree < Iso25331975::GroupThree
        include Iso25331997::GroupBaseMeters
      end

      module GroupBaseFeet
        def steps
          (
            (-16500..-13750).step(250) +
            (-14000..104800).step(200) +
            (105000..262500).step(500)
          )
        end

        def steps_unit
          :feet
        end
      end

      class GroupFour < Iso25331975::GroupOne
        include Iso25331997::GroupBaseFeet
      end

      class GroupFive < Iso25331975::GroupTwo
        include Iso25331997::GroupBaseFeet
      end

      class GroupSix < Iso25331975::GroupThree
        include Iso25331997::GroupBaseFeet
      end

      class << self
        def table_1
          GroupOne.new.to_h
        end

        def table_2
          GroupTwo.new.to_h
        end

        def table_3
          GroupThree.new.to_h
        end

        def table_4
          GroupFour.new.to_h
        end

        def table_5
          GroupFive.new.to_h
        end

        def table_6
          GroupSix.new.to_h
        end

        def table_1_yaml
          GroupOne.new.set_attrs.to_yaml
        end

        def table_2_yaml
          GroupTwo.new.set_attrs.to_yaml
        end

        def table_3_yaml
          GroupThree.new.set_attrs.to_yaml
        end

        def table_4_yaml
          GroupFour.new.set_attrs.to_yaml
        end

        def table_5_yaml
          GroupFive.new.set_attrs.to_yaml
        end

        def table_6_yaml
          GroupSix.new.set_attrs.to_yaml
        end
      end
    end
  end
end
