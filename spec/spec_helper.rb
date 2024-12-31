# frozen_string_literal: true

require "atmospheric"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec.shared_examples "yaml parsing and serialization" do |yaml_path, model_class|
  it "correctly parses and serializes YAML" do
    original_yaml = File.read(yaml_path)
    model_instance = model_class.from_yaml(original_yaml)
    generated_yaml = model_instance.to_yaml
    expect(YAML.load(generated_yaml.strip)).to eq(YAML.load(original_yaml.strip))
  end
end