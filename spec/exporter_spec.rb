require 'yaml'
require 'spec_helper'

describe Magnifier::Exporter do
  before do
    @magnifier = Magnifier.new([[1,2,3], [4,5,6],[7,8,9],[10,11,12]], 0.03)
    @magnifier.train
    @magnifier.instance_variable_set(:@f1_score, 0.85)
  end

  describe 'successfully exports' do
    it 'works with open files' do
      file = File.open('testfile.yaml', 'w')
      Magnifier::Exporter.export(file, @magnifier)
      expect(File.exist?(file)).to eq(true)
      expect(File.size?(file)).to_not eq(0)
      File.unlink(file)
    end

    it 'works with strings' do
      file_string = "testfile.yaml"
      file = Magnifier::Exporter.export(file_string, @magnifier)
      # File.size? chechs for existence and size simultaneously
      expect(File.size?(file.path)).to_not eq(0)
      File.unlink(file)
    end

    it 'export correctly' do
      file_string = "testfile.yaml"
      file = Magnifier::Exporter.export(file_string, @magnifier)

      yaml = YAML.load(File.open(file))
      @magnifier.instance_variables.each do |var_name|
        value_from_yaml = yaml[var_name.to_s.slice(1..-1)]
        value_from_object = @magnifier.instance_variable_get(var_name)
        value_from_object = value_from_object.to_a if value_from_object.respond_to?(:to_a)

        expect(value_from_object).to eq(value_from_yaml)
      end
      File.unlink(file)
    end
  end

end
