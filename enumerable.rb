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

  def my_none?(proc = nil,&block)
    !my_any?(proc,&block)
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

# array =  [4, 0, 6, 3, 5, 7, 1, 6, 5, 1, 6, 0, 6, 0, 4, 2, 5, 0, 0, 4, 0, 0, 3, 0, 6, 0, 4, 7, 3, 0, 3, 7, 4, 8, 5, 7, 1, 8, 5, 7, 0, 5, 3, 4, 3, 2, 6, 5, 5, 2, 0, 4, 1, 1, 8, 6, 4, 6, 0, 3, 2, 5, 7, 5, 6, 6, 7, 4, 2, 8, 3, 1, 4, 5, 8, 3, 6, 6, 8, 4, 4, 3, 8, 6, 4, 8, 8, 8, 2, 0, 5, 0, 4, 6, 6, 6, 2, 0, 0, 6]

# p array.inject(:+)

# p array.my_inject(:+)