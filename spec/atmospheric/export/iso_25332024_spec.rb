require "spec_helper"
require_relative "../../../lib/atmospheric/export/iso_25332024"

RSpec.describe "Iso25332024 Parsing and Serialization" do
  TABLE_MAPPINGS = [
    ["Table 5", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table5.yaml", Atmospheric::Export::Iso25332024::GroupOneMeters],
    ["Table 6", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table6.yaml", Atmospheric::Export::Iso25332024::GroupTwoMeters],
    ["Table 7", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table7.yaml", Atmospheric::Export::Iso25332024::GroupThreeMeters],
    ["Table 8", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table8.yaml", Atmospheric::Export::Iso25332024::GroupOneFeet],
    ["Table 9", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table9.yaml", Atmospheric::Export::Iso25332024::GroupTwoFeet],
    ["Table 10", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table10.yaml", Atmospheric::Export::Iso25332024::GroupThreeFeet],
    ["Table 11", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table11.yaml", Atmospheric::Export::Iso25332024::HypsometricalMbar],
    ["Table 12", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table12.yaml", Atmospheric::Export::Iso25332024::HypsometricalGeometric],
    ["Table 13", "spec/fixtures/iso2533/sources/iso-2533-2024/yaml/table13.yaml", Atmospheric::Export::Iso25332024::HypsometricalGeopotential]
  ]

  TABLE_MAPPINGS.each do |table_name, yaml_path, parser|
    context table_name do
      it_behaves_like "yaml parsing and serialization", yaml_path, parser
    end
  end
end
