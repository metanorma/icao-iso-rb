module Atmospheric
  module Export
    module Iso25331985
      class TableThreeAttrs < Lutaml::Model::Serializable
        attribute :pressure_mmhg, :float
        attribute :geopotential_altitude, :integer

        key_value do
          map "pressure-mmhg", to: :pressure_mmhg
          map "geopotential-altitude", to: :geopotential_altitude
        end
      end
    end
  end
end
