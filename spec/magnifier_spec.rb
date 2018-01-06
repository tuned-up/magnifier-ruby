# training sets and answers taken from
# https://www.coursera.org/learn/machine-learning/programming/fyhXS/anomaly-detection-and-recommender-systems
# TODO: rewrite using self-generated gaussian

require 'spec_helper'

describe Magnifier do
  before do
    @training_set = []
    File.open('spec/fixtures/small_2d_training_set.txt').each_line do |line|
      @training_set << line.split.map(&:to_f)
    end
    @cross_validation_set = []
    File.open('spec/fixtures/small_2d_cross_validation_set.txt').each_line do |line|
      @cross_validation_set << line.split.map(&:to_f)
    end
    @cross_validation_set_labels = []
    File.open('spec/fixtures/small_cross_validation_set_labels.txt').each_line do |line|
      @cross_validation_set_labels << line.to_f
    end
  end

  describe 'training with predefined threshold' do
    before do
      @magnifier = Magnifier.new(@training_set)
      @magnifier.train
    end

    it 'does not compute F1 score' do
      expect(@magnifier.f1_score).to eq(0)
    end

    describe 'default threshold' do
      it 'sets default threshold' do
        expect(@magnifier.threshold).to eq(0.01)
      end

      it 'detects an anomaly' do
        example = [11.5, 12.4]
        expect(@magnifier.anomaly?(example))
          .to be(true)
      end
    end

    describe 'custom threshold' do
      it 'sets custom threshold' do
        @magnifier.threshold = 0.01
        expect(@magnifier.threshold).to eq(0.01)
      end

      it 'detects an anomaly' do
        @magnifier.threshold = 0.001
        example = [10, 10]
        expect(@magnifier.threshold).to eq(0.001)
        expect(@magnifier.anomaly?(example)).to be(true)
      end

      it 'updates predictions with new threshold' do
        example = [12, 12]
        expect(@magnifier.threshold).to eq(0.01)
        expect(@magnifier.anomaly?(example)).to be(true)
        @magnifier.threshold = 0.001
        expect(@magnifier.anomaly?(example)).to be(false)
      end
    end
  end

  describe 'with adjusted threshold' do
    before do
      @magnifier = Magnifier.new(@training_set)
      @magnifier.train
      @magnifier.optimize_threshold(@cross_validation_set, @cross_validation_set_labels)
    end

    it 'successfully trains on training set' do
      expect(@magnifier.mu_vector).to eq([14.112225081433222, 14.997712052117272])
      expect(@magnifier.sigma_squared_vector).to eq([1.832632627481671, 1.7097421686169612])
    end

    it 'computes F1 score' do
      expect(@magnifier.f1_score).to eq(0.8750000000000001)
    end

    it 'picks correct epsilon' do
      expect(@magnifier.threshold).to eq(8.990857742033997e-05)
    end

    it 'detects an anomaly' do
      example = [0,0]
      expect(@magnifier.anomaly?(example))
        .to be(true)
    end
  end

end
