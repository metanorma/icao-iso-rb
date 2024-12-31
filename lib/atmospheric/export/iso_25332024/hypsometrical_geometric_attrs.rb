require "lutaml/model"

module Atmospheric
  module Export
    module Iso25332024
      class HypsometricalGeometricAttrs < Lutaml::Model::Serializable
        attribute :geometric_altitude_m, :integer
        attribute :pressure_mbar, :float

        key_value do
          map "geometric-altitude-m", to: :geometric_altitude_m
          map "pressure-mbar", to: :pressure_mbar
        end
      end
    end
  end
end
