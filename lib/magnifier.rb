require 'numo/narray'

class Magnifier
  # make configurable
  # or check for convergence
  LEARNING_STEPS = 1000

  attr_reader :training_set, :training_set_size, :features_count, :f1_score
  attr_accessor :mu_vector, :sigma_squared_vector, :threshold

  # examples is exepcted to be 2-D array of real values
  def initialize(examples, threshold = 0.01)
    @training_set = Numo::DFloat[*examples].freeze
    @training_set_size, @features_count = training_set.shape
    @threshold = threshold
    @mu_vector = Numo::DFloat.zeros(@features_count)
    @sigma_squared_vector = Numo::DFloat.zeros(@features_count)
    @f1_score = 0
  end

  def train
    @mu_vector = @training_set.mean(0)
    @sigma_squared_vector = (((training_set - mu_vector) ** 2).sum(0) / training_set_size).to_a
  end

  # optimize using F1 score
  # requires cross-validation set (should differ from train set!)
  # todo: convert base truth to boolean
  def optimize_threshold(examples, base_truths)
    boolean_base_thruths = base_truths.map{ |value| value == 1 || value == true }
    examples_prob = examples.map { |example| probability(example) }

    threshold_step = (examples_prob.max - examples_prob.min) / LEARNING_STEPS
    @threshold = 0

    (examples_prob.min..examples_prob.max).step(threshold_step) do |new_threshold|
      predictions = examples_prob.map { |probability| probability < new_threshold }
      current_f1 = compute_f1_score(predictions, boolean_base_thruths)

      if current_f1 > @f1_score
        @f1_score = current_f1
        @threshold = new_threshold
      end
    end

    [threshold, f1_score]
  end

  def probability(example)
    probability = 1
    example.each_with_index do |feature, i|
      feature_prob = Math.exp(-((feature - mu_vector[i])**2 / (2 * sigma_squared_vector[i]))) / ((2 * Math::PI * sigma_squared_vector[i])**(0.5))

      probability = probability * feature_prob
    end

    probability
  end

  def anomaly?(example)
    probability(example) < threshold
  end

  private

    def compute_f1_score(predictions, base_truths)
      true_positives  = predictions.map.with_index { |val, i| val && base_truths[i] }.count(true)
      false_positives = predictions.map.with_index { |val, i| val && !base_truths[i] }.count(true)
      false_negatives = predictions.map.with_index { |val, i| !val && base_truths[i] }.count(true)

      return 0 if true_positives == 0

      precision = true_positives.to_f / (true_positives + false_positives);
      recall = true_positives.to_f / (true_positives + false_negatives);

      (2 * precision * recall) / (precision + recall) rescue 0;
    end
end
