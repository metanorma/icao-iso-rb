module Atmospheric
  module Export
    module Iso25331985
      class TableFiveSixAttrs < Lutaml::Model::Serializable
        attribute :geopotential_altitude, :integer
        attribute :pressure_mbar, :float
        attribute :pressure_mmhg, :float

        key_value do
          map "geopotential-altitude", to: :geopotential_altitude
          map "pressure-mbar", to: :pressure_mbar
          map "pressure-mmhg", to: :pressure_mmhg
        end
      end
    end
  end
end
