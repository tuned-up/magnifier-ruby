# Magnifier

## Anomaly detection library

### What
  This anomaly detection library spins around gaussian/normal distribution. In this distribution, most examples revolves around some mean value and probability of some value drops the futher away it goes from mean. Therefore, it is possible to compute probabilty of each example in some dataset and label examples, which probabilities are less then some threshold as anomalies.

  Basic structure of working with such algorithm is:
  1. Collect training data (it should mostly be negative, non-anomaly examples)
  2. Learn mu and sigma out of each feature in training set, provided it is normally distributed
  3. (optional, but recommended) Optimize threshold on cross-validation set, which should contain anomalies (around 50%). Currently, only [F1 score](https://en.wikipedia.org/wiki/F1_score) is optimized.
  4. With learned threshold, it is now possible to make predictions about new example

### How

  ```ruby
  # training set should an MxN matrix, where M is a number of examples, and N is a number of features.
  #It should all be real-valued numbers, and each feature should be normally distributed in order for algorithm to work well.
  #It should also consist of only non-anomalies, positive examples.
  training_set = [[1,2,3,..], [3,2,4,..], [4,2,1,..], ...]
  @magnifier = Magnifier.new(@training_set)
  @magnifier.train
  @magnifier.anomaly?([44, 55,..])
  # => true

  # default threshold is 0.01, but it is possible to train it automatically. It will require 2 arrays:
  # first array is set of positive and negative examples (could be around 40-60% of training set)
  cross_validation_set = [[1,2,3,..], [5,1,6,..], ...]
  # second array consists of labels for the first one (true of 1 means anomaly, false or 0 means non-anomaly), and indexes should match.
  # E.g., if first example is anomaly, and second is not, then:
  # cross_validation_labels[0] == true and cross_validation_labels[1] == false
  cross_validation_labels = [true, false, ...]
  @magnifier.optimize_threshold(cross_validation_set, cross_validation_labels)
  @magnifier.threshold
  # => something with best f1 score
  ```

### Why

  I completed a couse in machine learning and had some free time to apply it.

### Todo

  Refer to todo.md

