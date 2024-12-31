require "lutaml/model"

module Atmospheric
  module Export
    module Iso25332024
      class HypsometricalMbarAttrs < Lutaml::Model::Serializable
        attribute :pressure_mbar, :float
        attribute :geopotential_altitude_m, :float
        attribute :geopotential_altitude_ft, :integer
        attribute :geometric_altitude_m, :float
        attribute :geometric_altitude_ft, :integer

        key_value do
          map "pressure-mbar", to: :pressure_mbar
          map "geopotential-altitude-m", to: :geopotential_altitude_m
          map "geopotential-altitude-ft", to: :geopotential_altitude_ft
          map "geometric-altitude-m", to: :geometric_altitude_m
          map "geometric-altitude-ft", to: :geometric_altitude_ft
        end
      end
    end
  end
end
