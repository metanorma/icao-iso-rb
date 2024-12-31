require "lutaml/model"

module Atmospheric
  module Export
    module Iso25332024
      class HypsometricalGeopotentialAttrs < Lutaml::Model::Serializable
        attribute :geopotential_altitude_m, :integer
        attribute :pressure_mbar, :float

        key_value do
          map "geopotential-altitude-m", to: :geopotential_altitude_m
          map "pressure-mbar", to: :pressure_mbar
        end
      end
    end
  end
end
