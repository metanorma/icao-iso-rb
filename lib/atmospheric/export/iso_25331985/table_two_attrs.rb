require "lutaml/model"

module Atmospheric
  module Export
    module Iso25331985
      class TableTwoAttrs < Lutaml::Model::Serializable
        attribute :pressure_mbar, :float
        attribute :geopotential_altitude, :integer

        key_value do
          map "pressure-mbar", to: :pressure_mbar
          map "geopotential-altitude", to: :geopotential_altitude
        end
      end
    end
  end
end
