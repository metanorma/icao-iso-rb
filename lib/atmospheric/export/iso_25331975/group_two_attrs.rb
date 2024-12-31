require "lutaml/model"

module Atmospheric
  module Export
    module Iso25331975
      class GroupTwoAttrs < Lutaml::Model::Serializable
        attribute :geometrical_altitude_m, :integer
        attribute :geometrical_altitude_ft, :integer
        attribute :geopotential_altitude_m, :integer
        attribute :geopotential_altitude_ft, :integer
        attribute :ppn, :float
        attribute :rhorhon, :float
        attribute :sqrt_rhorhon, :float
        attribute :speed_of_sound, :integer
        attribute :dynamic_viscosity, :float
        attribute :kinematic_viscosity, :float
        attribute :thermal_conductivity, :float

        key_value do
          map "geometrical-altitude-m", to: :geometrical_altitude_m
          map "geometrical-altitude-ft", to: :geometrical_altitude_ft
          map "geopotential-altitude-m", to: :geopotential_altitude_m
          map "geopotential-altitude-ft", to: :geopotential_altitude_ft
          map "ppn", to: :ppn
          map "rhorhon", to: :rhorhon
          map "sqrt-rhorhon", to: :sqrt_rhorhon
          map "speed-of-sound", to: :speed_of_sound
          map "dynamic-viscosity", to: :dynamic_viscosity
          map "kinematic-viscosity", to: :kinematic_viscosity
          map "thermal-conductivity", to: :thermal_conductivity
        end
      end
    end
  end
end
