module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    item = 0
    while item < size
      yield self[item]
      item += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    item = 0
    index = 0
    yield self[item], index while item < size
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |item| new_arr << item if yield item }
    new_arr
  end

  # rubocop:todo Metrics/PerceivedComplexity
  def my_all?(arg = nil, &block) # rubocop:todo Metrics/CyclomaticComplexity
    case
    when block_given? then my_each { |i| return false unless block.call(i) }

    when arg.nil? then my_each { |i| return false unless i }

    when arg.class == Class then my_each { |i| return false unless i.is_a?(arg) }

    when arg.class == Regexp then my_each { |i| return false unless i =~ arg }

    else my_each { |i| return false unless i == arg }
    end
    true
  end
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:todo Metrics/PerceivedComplexity
  def my_any?(arg = nil, &block) # rubocop:todo Metrics/CyclomaticComplexity
    case
    when block_given? then my_each { |i| return true if block.call(i) }

    when arg.nil? then my_each { |i| return true if i }

    when arg.class == Class then my_each { |i| return true if i.is_a?(arg) }

    when arg.class == Regexp then my_each { |i| return true if i =~ arg }

    else my_each { |i| return true if i == arg }
    end
    false
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def my_none?
    !my_any?
  end

  def my_count(arg = nil)
    counter = 0
    if block_given? then my_each { |item| counter += 1 if yield(item) == true }

    elsif arg.nil? then my_each { counter += 1 }

    else my_each { |item| counter += 1 if item == arg }
    end
    counter
  end

  def my_map(proc = nil)
    return to_enum(:my_map!) unless block_given?

    result = []
    if proc.nil?
      my_each { |i| result << yield(i) }
    else
      my_each { |i| result << proc.call(i) }
    end
    result
  end

  def my_inject(current = 0)
    return enum_for(:my_inject) unless block_given?

    acc = current.nil? ? first : current
    my_each { |item| acc = yield(acc, item) }
    acc
  end
end

# rubocop:enable

def multiply_els(arr)
  arr.my_inject(1) { |acc, current_val| acc * current_val }
end
