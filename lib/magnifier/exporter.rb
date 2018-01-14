require 'yaml'

class Magnifier::Exporter

  attr_reader :magnifier_object, :path_object

  def self.export(path_object, magnifier_object)
    new(path_object, magnifier_object).export
  end

  def initialize(path_object, magnifier_object)
    @path_object = path_object
    @magnifier_object = magnifier_object
  end

  def export
    file = File.open(@path_object, 'w')
    file.write(compose_yaml)
    file.close

    file
  end

  private

    def compose_yaml
      result = {}
      @magnifier_object.instance_variables.each do |var_name|
        value = @magnifier_object.instance_variable_get(var_name)
        value = value.to_a if value.respond_to?(:to_a) # convert martixes to arrays

        result[var_name.to_s.slice(1..-1)] = value
      end

      result.to_yaml
    end
end
