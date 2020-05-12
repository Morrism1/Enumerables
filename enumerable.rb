module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    array = to_a
    item = 0
    while item < size
      yield(array[item])
      item += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    item = 0
    while item < size
      yield self[item], item
      item += 1
    end

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

  def my_none?(proc = nil, &block)
    !my_any?(proc, &block)
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

  def my_inject(current = nil, second = nil)
    arr = to_a
    acc = arr[0]

    acc = yield(current, acc) if block_given? && !current.nil?
    acc = acc.send(second, current) unless second.nil?
    (1..arr.size - 1).my_each do |i|
      acc = if block_given?
              yield(acc, arr[i])
            elsif second.nil?
              acc.send(current, arr[i])
            else
              acc.send(second, arr[i])
            end
    end
    acc
  end
end

# rubocop:enable

def multiply_els(arr)
  arr.my_inject(1) { |acc, current_val| acc * current_val }
end
