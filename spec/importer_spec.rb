require 'yaml'
require 'spec_helper'

describe Magnifier::Importer do
  before do
    @magnifier_orig = Magnifier.new([[1,2,3],[4,5,6],[7,8,9],[10,11,12]], 0.03)
    @magnifier_orig.train
    @magnifier_orig.instance_variable_set(:@f1_score, 0.85)
    @file_path = "testfile.yaml"
    Magnifier::Exporter.export(@file_path, @magnifier_orig)
  end

  describe 'successfully imports' do
    describe 'when Magnifier object passed' do
      before do
        @magnifier = Magnifier.new([])
      end

      it 'uses existing object' do
        magnifier = Magnifier::Importer.import(@file_path, @magnifier)
        expect(magnifier.object_id).to_not eq(@magnifier_orig.object_id)
        expect(magnifier.object_id).to eq(@magnifier.object_id)
      end

      it 'rewrites existing object' do
        @magnifier.instance_variable_set(:@f1_score, -1)
        Magnifier::Importer.import(@file_path, @magnifier)
        expect(@magnifier.f1_score).to eq(0.85)
      end

      it 'imports correctly' do
        Magnifier::Importer.import(@file_path, @magnifier)
        @magnifier.instance_variables.each do |var_name|
          expect(@magnifier.instance_variable_get(var_name))
            .to eq @magnifier_orig.instance_variable_get(var_name)
        end
      end
    end

    describe 'when Magnifier object not passed' do
      it 'creates Magnifier object' do
        magnifier = Magnifier::Importer.import(@file_path)
        expect(magnifier.object_id).to_not eq(@magnifier_orig.object_id)
      end

      it 'import correctly' do
        magnifier = Magnifier::Importer.import(@file_path)
        magnifier.instance_variables.each do |var_name|
          expect(magnifier.instance_variable_get(var_name))
            .to eq @magnifier_orig.instance_variable_get(var_name)
        end
      end
    end

    after(:all) do
      File.unlink("testfile.yaml")
    end
  end


end
