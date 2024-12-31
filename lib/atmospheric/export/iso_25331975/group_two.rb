require_relative "./group_base"
require_relative "group_two_attrs"
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
      class GroupTwo < GroupBase
        attribute :by_geometrical_altitude, GroupTwoAttrs, collection: true
        attribute :by_geopotential_altitude, GroupTwoAttrs, collection: true

        key_value do
          map "by-geometrical-altitude", to: :by_geometrical_altitude
          map "by-geopotential-altitude", to: :by_geopotential_altitude
        end

        # In meters only
        def row_from_geopotential(gp_h_f)
          {
            "ppn"                  => round_to_sig_figs(Isa.p_p_n_from_geopotential(gp_h_f), 6),
            "rhorhon"              => round_to_sig_figs(Isa.rho_rho_n_from_geopotential(gp_h_f), 6),
            "sqrt-rhorhon"         => round_to_sig_figs(Isa.root_rho_rho_n_from_geopotential(gp_h_f), 6),
            "speed-of-sound"       => (Isa.speed_of_sound_from_geopotential(gp_h_f) * 1000.0).round,
            "dynamic-viscosity"    => round_to_sig_figs(Isa.dynamic_viscosity_from_geopotential(gp_h_f), 5),
            "kinematic-viscosity"  => round_to_sig_figs(Isa.kinematic_viscosity_from_geopotential(gp_h_f), 5),
            "thermal-conductivity" => round_to_sig_figs(Isa.thermal_conductivity_from_geopotential(gp_h_f), 5),
          }
        end

        def set_attrs
          super(klass: GroupTwoAttrs)
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
