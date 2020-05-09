module Enumerable
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_each
    return to_enum(:my_each) unless block_given?

    item = 0
    while item < size
      yield self[item]
      item += 1
    end
    self
  end
end


