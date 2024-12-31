require_relative "./group_base"
require_relative "group_three_attrs"
require "bigdecimal"
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Layout/LineLength
# rubocop:disable Layout/HashAlignment
module Atmospheric
  module Export
    module Iso25331975
      class GroupThree < GroupBase
        attribute :by_geometrical_altitude, GroupThreeAttrs, collection: true
        attribute :by_geopotential_altitude, GroupThreeAttrs, collection: true

        key_value do
          map "by-geometrical-altitude", to: :by_geometrical_altitude
          map "by-geopotential-altitude", to: :by_geopotential_altitude
        end

        # In meters only
        def row_from_geopotential(gp_h_f)
          {
            "pressure-scale-height" => Isa.pressure_scale_height_from_geopotential(gp_h_f).round(1),
            "specific-weight"       => round_to_sig_figs(Isa.specific_weight_from_geopotential(gp_h_f), 5),
            "air-number-density"    => round_to_sig_figs(Isa.air_number_density_from_geopotential(gp_h_f), 5),
            "mean-speed"            => Isa.mean_air_particle_speed_from_geopotential(gp_h_f).round(2),
            "frequency"             => round_to_sig_figs(Isa.air_particle_collision_frequency_from_geopotential(gp_h_f), 5),
            "mean-free-path"        => round_to_sig_figs(Isa.mean_free_path_of_air_particles_from_geopotential(gp_h_f), 5),
          }
        end

        def set_attrs
          super(klass: GroupThreeAttrs)
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Layout/LineLength
# rubocop:enable Layout/HashAlignment
