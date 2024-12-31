require_relative "./target"
require "lutaml/model"
require_relative "./iso_25332024/hypsometrical_mbar_attrs"
module Atmospheric
  module Export
    module HypsometricalTables
      class TableBase < Lutaml::Model::Serializable
        include Target

        attribute :rows, Iso25332024::HypsometricalMbarAttrs, collection: true

        def to_h(unit: steps_unit)
          { "rows" => steps.inject([]) do |rows, p|
            rows << row(p, unit: unit)
          end }
        end

        def steps
          (0..0)
        end

        def steps_unit
          :mbar
        end

        def row(_p, unit: steps_unit)
          {}
        end

        def set_attrs(klass:, unit: steps_unit)
          self.rows = []
          steps.each do |p|
            rows << klass.from_json(row(p, unit: unit).to_json)
          end
          self
        end
      end
    end
  end
end
