require "spec_helper"
require_relative "../../../lib/atmospheric/export/iso_25331975"

RSpec.describe "Iso25331975 Parsing and Serialization" do
  TABLE_MAPPINGS = [
    ["Table 5", "spec/fixtures/iso2533/sources/iso-2533-1975-new/yaml/table5.yaml", Atmospheric::Export::Iso25331975::GroupOne],
    ["Table 6", "spec/fixtures/iso2533/sources/iso-2533-1975-new/yaml/table6.yaml", Atmospheric::Export::Iso25331975::GroupTwo],
    ["Table 7", "spec/fixtures/iso2533/sources/iso-2533-1975-new/yaml/table7.yaml", Atmospheric::Export::Iso25331975::GroupThree]
  ]

  TABLE_MAPPINGS.each do |table_name, yaml_path, parser|
    context table_name do
      it_behaves_like "yaml parsing and serialization", yaml_path, parser
    end
  end
end
