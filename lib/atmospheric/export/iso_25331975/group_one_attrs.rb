require "lutaml/model"

module Atmospheric
  module Export
    module Iso25331975
      class GroupOneAttrs < Lutaml::Model::Serializable
        attribute :geometrical_altitude_m, :integer
        attribute :geometrical_altitude_ft, :integer
        attribute :geopotential_altitude_m, :integer
        attribute :geopotential_altitude_ft, :integer
        attribute :temperature_k, :integer
        attribute :temperature_c, :integer
        attribute :pressure_mbar, :float
        attribute :pressure_mmhg, :float
        attribute :density, :float
        attribute :acceleration, :float

        key_value do
          map "geometrical-altitude-m", to: :geometrical_altitude_m
          map "geometrical-altitude-ft", to: :geometrical_altitude_ft
          map "geopotential-altitude-m", to: :geopotential_altitude_m
          map "geopotential-altitude-ft", to: :geopotential_altitude_ft
          map "temperature-K", to: :temperature_k
          map "temperature-C", to: :temperature_c
          map "pressure-mbar", to: :pressure_mbar
          map "pressure-mmhg", to: :pressure_mmhg
          map "density", to: :density
          map "acceleration", to: :acceleration
        end
      end
    end
  end
end
