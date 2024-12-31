require_relative "./target"
require_relative "./hypsometrical_tables"
require_relative "./iso_25331975"
require_relative "iso_25332024/hypsometrical_geometric_attrs"
require_relative "iso_25332024/hypsometrical_geopotential_attrs"

module Atmospheric
  module Export
    module Iso25332024
      module GroupBaseMeters
        def steps
          (
            (-5000..31950).step(50) +
            (32000..50900).step(100) +
            (51000..80000).step(200)
          )
        end
      end

      class GroupOneMeters < Iso25331975::GroupOne
        include Iso25332024::GroupBaseMeters
      end

      class GroupTwoMeters < Iso25331975::GroupTwo
        include Iso25332024::GroupBaseMeters
      end

      class GroupThreeMeters < Iso25331975::GroupThree
        include Iso25332024::GroupBaseMeters
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

      class GroupOneFeet < Iso25331975::GroupOne
        include Iso25332024::GroupBaseFeet
      end

      class GroupTwoFeet < Iso25331975::GroupTwo
        include Iso25332024::GroupBaseFeet
      end

      class GroupThreeFeet < Iso25331975::GroupThree
        include Iso25332024::GroupBaseFeet
      end

      class HypsometricalMbar < HypsometricalTables::TableBase
        # TODO: when Ruby's step does not create inaccurate floating point numbers
        # This is a hack to solve a Ruby bug with floating point calcuations
        # > (20.0..1770.9).step(0.1).to_a
        #  ...
        #  1769.4,
        #  1769.5,
        #  1769.6000000000001, # <== we need to clean these
        #  1769.7,
        #  1769.8000000000002, # <== we need to clean these
        # The last `map` should be removed if this bug is fixed
        def steps
          (
            (5.0..19.99).step(0.01).to_a.map { |v| v.round(2) } +
            (20.0..1770.9).step(0.1).to_a.map { |v| v.round(1) }
          )
        end

        def steps_unit
          :mbar
        end

        def row(p, unit:)
          method_name = "geopotential_altitude_from_pressure_#{unit}"
          gp_h_m = Isa.send(method_name, p)
          gp_h_ft = m_to_ft(gp_h_m)
          gm_h_m = Isa.geometric_altitude_from_geopotential(gp_h_m)
          gm_h_ft = m_to_ft(gm_h_m)
          {
            "pressure-#{unit}" => p,
            "geopotential-altitude-m" => gp_h_m.round(1),
            "geopotential-altitude-ft" => gp_h_ft.round,
            "geometric-altitude-m" => gm_h_m.round(1),
            "geometric-altitude-ft" => gm_h_ft.round,
          }
        end

        def set_attrs
          super(klass: HypsometricalMbarAttrs)
        end
      end

      class HypsometricalGeometric < HypsometricalTables::TableBase
        def steps
          (-1000..4599).step(1)
        end

        def row(hgmm, unit:)
          hgpm = Isa.geopotential_altitude_from_geometric(hgmm)
          {
            "geometric-altitude-m" => hgpm,
            "pressure-mbar" => round_to_sig_figs(
              Isa.pressure_from_geopotential_mbar(hgpm.to_f), 6
            ),
            # "pressure-mmhg" => round_to_sig_figs(Isa.pressure_from_geopotential_mmhg(hgpm.to_f), 6),
          }
        end

        def set_attrs
          super(klass: HypsometricalGeometricAttrs)
        end
      end

      class HypsometricalGeopotential < HypsometricalTables::TableBase
        def steps
          (-1000..4599).step(1)
        end

        def row(hgpm, unit:)
          {
            "geopotential-altitude-m" => hgpm,
            "pressure-mbar" => round_to_sig_figs(
              Isa.pressure_from_geopotential_mbar(hgpm.to_f), 6
            ),
            # "pressure-mmhg" => round_to_sig_figs(Isa.pressure_from_geopotential_mmhg(hgpm.to_f), 6),
          }
        end

        def set_attrs
          super(klass: HypsometricalGeopotentialAttrs)
        end
      end

      class << self
        def table_5
          GroupOneMeters.new.to_h
        end

        def table_6
          GroupTwoMeters.new.to_h
        end

        def table_7
          GroupThreeMeters.new.to_h
        end

        def table_8
          GroupOneFeet.new.to_h
        end

        def table_9
          GroupTwoFeet.new.to_h
        end

        def table_10
          GroupThreeFeet.new.to_h
        end

        def table_11
          HypsometricalMbar.new.to_h
        end

        def table_12
          HypsometricalGeometric.new.to_h
        end

        def table_13
          HypsometricalGeopotential.new.to_h
        end

        def table_5_yaml
          GroupOneMeters.new.set_attrs.to_yaml
        end

        def table_6_yaml
          GroupTwoMeters.new.set_attrs.to_yaml
        end

        def table_7_yaml
          GroupThreeMeters.new.set_attrs.to_yaml
        end

        def table_8_yaml
          GroupOneFeet.new.set_attrs.to_yaml
        end

        def table_9_yaml
          GroupTwoFeet.new.set_attrs.to_yaml
        end

        def table_10_yaml
          GroupThreeFeet.new.set_attrs.to_yaml
        end

        def table_11_yaml
          HypsometricalMbar.new.set_attrs.to_yaml
        end

        def table_12_yaml
          HypsometricalGeometric.new.set_attrs.to_yaml
        end

        def table_13_yaml
          HypsometricalGeopotential.new.set_attrs.to_yaml
        end
      end
    end
  end
end
