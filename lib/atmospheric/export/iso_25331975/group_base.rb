require_relative "../target"
require "lutaml/model"

module Atmospheric
  module Export
    module Iso25331975
      class GroupBase < Lutaml::Model::Serializable
        include Target

        def row_big_h(h, unit: :meters)
          hgpm, hgpf = values_in_m_ft(h, unit: unit)
          hgmm = Isa.geometric_altitude_from_geopotential(hgpm)
          hgmf = m_to_ft(hgmm).round
          height_hash(hgmm, hgmf, hgpm, hgpf)
            .merge(row_from_geopotential(hgpm))
        end

        def row_small_h(h, unit: :meters)
          hgmm, hgmf = values_in_m_ft(h, unit: unit)
          hgpm = Isa.geopotential_altitude_from_geometric(hgmm)
          hgpf = m_to_ft(hgpm).round
          height_hash(hgmm, hgmf, hgpm, hgpf)
            .merge(row_from_geopotential(hgpm))
        end

        def height_hash(hgmm, hgmf, hgpm, hgpf)
          {
            "geometrical-altitude-m" => hgmm.round,
            "geometrical-altitude-ft" => hgmf.round,
            "geopotential-altitude-m" => hgpm.round,
            "geopotential-altitude-ft" => hgpf.round,
          }
        end

        def values_in_m_ft(value, unit: :meters)
          case unit
          when :meters
            [value.to_f, m_to_ft(value)]
          when :feet
            [ft_to_m(value), value.to_f]
          end
        end

        # Step 50 from -2k to 40k, step 100 above 32k, 200 above 51k to 80k
        def steps
          (
            (-2000..31950).step(50) +
            (32000..50900).step(100) +
            (51000..80000).step(200)
          )
        end

        def steps_unit
          :meters
        end

        def to_h(unit: steps_unit)
          steps.inject({ "by-geometrical-altitude" => [],
                         "by-geopotential-altitude" => [] }) do |result, h|
            result["by-geometrical-altitude"] << row_small_h(h, unit: unit)
            result["by-geopotential-altitude"] << row_big_h(h, unit: unit)
            result
          end
        end

        def set_attrs(klass:, unit: steps_unit)
          self.by_geometrical_altitude = []
          self.by_geopotential_altitude = []

          steps.each do |h|
            by_geometrical_altitude << klass.from_json(row_small_h(h,
                                                                   unit: unit).to_json)
            by_geopotential_altitude << klass.from_json(row_big_h(h,
                                                                  unit: unit).to_json)
          end
          self
        end
      end
    end
  end
end
