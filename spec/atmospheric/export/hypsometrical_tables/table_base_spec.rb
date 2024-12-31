require "spec_helper"
require_relative "../../../../lib/atmospheric"

RSpec.describe Atmospheric::Export::Iso25331985::TableOne do
  let(:table_one) { described_class.new }
  let(:mock_row) do
    {
      "pressure-mbar" => 10.0,
      "geopotential-altitude" => 500,
    }
  end

  before do
    allow(table_one).to receive(:row).and_return(mock_row)
  end

  describe "#set_attrs" do
    subject { table_one.set_attrs }

    it "sets rows to an array of TableOneAttrs instances" do
      subject
      expect(table_one.rows).to all(be_a(Atmospheric::Export::Iso25331985::TableOneAttrs))
      expect(table_one.rows.first.pressure_mbar).to eq(mock_row["pressure-mbar"])
    end

    it "calls row for each step to populate rows" do
      expect(table_one).to receive(:row).exactly(table_one.steps.count).times
      subject
    end

    it "returns itself after setting attributes" do
      expect(subject).to eq(table_one)
    end

    context "with realistic data" do
      let(:mock_row) do
        {
          "pressure-mbar" => 1013.25,
          "geopotential-altitude" => 0,
        }
      end

      before do
        allow(table_one).to receive(:row).and_return(mock_row)
      end

      it "populates rows with correct values" do
        subject
        expect(table_one.rows.first.pressure_mbar).to eq(mock_row["pressure-mbar"])
        expect(table_one.rows.first.geopotential_altitude).to eq(mock_row["geopotential-altitude"])
      end
    end
  end
end
