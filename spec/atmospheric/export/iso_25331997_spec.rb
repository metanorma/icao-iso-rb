require "spec_helper"
require_relative "../../../lib/atmospheric/export/iso_25331997"

RSpec.describe "Iso25331997 Parsing and Serialization" do
  TABLE_MAPPINGS = [
    ["Table 1", "spec/fixtures/iso2533/sources/iso-2533-add-2-1997-new/yaml/table1.yaml", Atmospheric::Export::Iso25331997::GroupOne],
    ["Table 2", "spec/fixtures/iso2533/sources/iso-2533-add-2-1997-new/yaml/table2.yaml", Atmospheric::Export::Iso25331997::GroupTwo],
    ["Table 3", "spec/fixtures/iso2533/sources/iso-2533-add-2-1997-new/yaml/table3.yaml", Atmospheric::Export::Iso25331997::GroupThree],
    ["Table 4", "spec/fixtures/iso2533/sources/iso-2533-add-2-1997-new/yaml/table4.yaml", Atmospheric::Export::Iso25331997::GroupFour],
    ["Table 5", "spec/fixtures/iso2533/sources/iso-2533-add-2-1997-new/yaml/table5.yaml", Atmospheric::Export::Iso25331997::GroupFive],
    ["Table 6", "spec/fixtures/iso2533/sources/iso-2533-add-2-1997-new/yaml/table6.yaml", Atmospheric::Export::Iso25331997::GroupSix]
  ]

  TABLE_MAPPINGS.each do |table_name, yaml_path, parser|
    context table_name do
      it_behaves_like "yaml parsing and serialization", yaml_path, parser
    end
  end
end
