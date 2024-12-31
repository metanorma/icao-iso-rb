require "spec_helper"
require_relative "../../../../lib/atmospheric"

RSpec.describe Atmospheric::Export::Iso25331975::GroupOne do
  let(:group_one) { described_class.new }
  let(:mock_attrs) do
    {
      "geometrical-altitude-m" => 1000,
      "geometrical-altitude-ft" => 3280,
      "geopotential-altitude-m" => 990,
      "geopotential-altitude-ft" => 3250,
      "temperature-K" => 273,
      "temperature-C" => 0,
      "pressure-mbar" => 1013.25,
      "pressure-mmhg" => 760.0,
      "density" => 1.225,
      "acceleration" => 9.81,
    }
  end

  before do
    allow(group_one).to receive(:row_small_h).and_return(mock_attrs)
    allow(group_one).to receive(:row_big_h).and_return(mock_attrs)
  end

  describe "#set_attrs" do
    subject { group_one.set_attrs }

    it "sets by_geometrical_altitude to an array of GroupOneAttrs instances" do
      subject
      expect(group_one.by_geometrical_altitude).to all(be_a(Atmospheric::Export::Iso25331975::GroupOneAttrs))
      expect(group_one.by_geometrical_altitude.first.geometrical_altitude_m).to eq(mock_attrs["geometrical-altitude-m"])
    end

    it "sets by_geopotential_altitude to an array of GroupOneAttrs instances" do
      subject
      expect(group_one.by_geopotential_altitude).to all(be_a(Atmospheric::Export::Iso25331975::GroupOneAttrs))
      expect(group_one.by_geopotential_altitude.first.geopotential_altitude_m).to eq(mock_attrs["geopotential-altitude-m"])
    end

    it "calls row_small_h for each step to populate by_geometrical_altitude" do
      expect(group_one).to receive(:row_small_h).exactly(group_one.steps.count).times
      subject
    end

    it "calls row_big_h for each step to populate by_geopotential_altitude" do
      expect(group_one).to receive(:row_big_h).exactly(group_one.steps.count).times
      subject
    end

    it "returns itself after setting attributes" do
      expect(subject).to eq(group_one)
    end

    context "with realistic data" do
      let(:mock_row_small_h) do
        {
          "geometrical-altitude-m" => 2000,
          "geometrical-altitude-ft" => 6562,
          "geopotential-altitude-m" => 1980,
          "geopotential-altitude-ft" => 6496,
          "temperature-K" => 268,
          "temperature-C" => -5,
          "pressure-mbar" => 795.0,
          "pressure-mmhg" => 596.1,
          "density" => 1.006,
          "acceleration" => 9.78,
        }
      end

      before do
        allow(group_one).to receive(:row_small_h).and_return(mock_row_small_h)
        allow(group_one).to receive(:row_big_h).and_return(mock_row_small_h)
      end

      it "populates by_geometrical_altitude with correct values" do
        subject
        expect(group_one.by_geometrical_altitude.first.temperature_k).to eq(mock_row_small_h["temperature-K"])
        expect(group_one.by_geometrical_altitude.first.pressure_mbar).to eq(mock_row_small_h["pressure-mbar"])
      end

      it "populates by_geopotential_altitude with correct values" do
        subject
        expect(group_one.by_geopotential_altitude.first.temperature_k).to eq(mock_row_small_h["temperature-K"])
        expect(group_one.by_geopotential_altitude.first.pressure_mbar).to eq(mock_row_small_h["pressure-mbar"])
      end
    end
  end
end
