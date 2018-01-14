require 'yaml'

class Magnifier::Importer

  attr_reader :magnifier_object, :path_object

  def self.import(path_object, magnifier_object = Magnifier.new([[0],[0]]))
    new(path_object, magnifier_object).import
  end

  def initialize(path_object, magnifier_object)
    @path_object = path_object
    @magnifier_object = magnifier_object
  end

  def import
    yaml_content = {}
    File.open(@path_object, 'r') do |file|
      yaml_content = YAML.load(file.read)
    end

    yaml_content.each_pair do |key, value|
      value = Numo::DFloat[*value] if value.is_a?(Array)
      @magnifier_object.instance_variable_set("@#{key}", value)
    end

    @magnifier_object
  end
end
