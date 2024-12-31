require "lutaml/model"

module Atmospheric
  module Export
    module Iso25331975
      class GroupThreeAttrs < Lutaml::Model::Serializable
        attribute :geometrical_altitude_m, :integer
        attribute :geometrical_altitude_ft, :integer
        attribute :geopotential_altitude_m, :integer
        attribute :geopotential_altitude_ft, :integer
        attribute :pressure_scale_height, :float
        attribute :specific_weight, :float
        attribute :air_number_density, :float
        attribute :mean_speed, :float
        attribute :frequency, :float
        attribute :mean_free_path, :float

        key_value do
          map "geometrical-altitude-m", to: :geometrical_altitude_m
          map "geometrical-altitude-ft", to: :geometrical_altitude_ft
          map "geopotential-altitude-m", to: :geopotential_altitude_m
          map "geopotential-altitude-ft", to: :geopotential_altitude_ft
          map "pressure-scale-height", to: :pressure_scale_height
          map "specific-weight", to: :specific_weight
          map "air-number-density", to: :air_number_density
          map "mean-speed", to: :mean_speed
          map "frequency", to: :frequency
          map "mean-free-path", to: :mean_free_path
        end
      end
    end
  end
end
