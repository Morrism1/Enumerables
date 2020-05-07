module Enumerable
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_each
    return to_enum(:my_each) unless block_given?

    item = 0
    while item < self.size
      yield self[item]
      item += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    item = 0
    index = 0
    while item < self.size
      yield self[item], index
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |item| new_arr << item if yield item }
    new_arr
  end

  def my_all?(arg = nil, &block)
    case
    when block_given? then my_each { |i| return false unless block.call(i) }

    when arg.nil? then my_each { |i| return false unless i }

    when arg.class == Class then my_each { |i| return false unless i.is_a?(arg) }

    when arg.class == Regexp then my_each { |i| return false unless i =~ arg }

    else my_each { |i| return false unless i == arg }
    end
    true
  end

  def my_any?(arg = nil, &block)
    case
    when block_given? then my_each { |i| return true if block.call(i) }

    when arg.nil? then my_each { |i| return true if i }

    when arg.class == Class then my_each { |i| return true if i.is_a?(arg) }

    when arg.class == Regexp then my_each { |i| return true if i =~ arg }

    else my_each { |i| return true if i == arg }
    end
    false
  end

  def my_none?
    !my_any?
  end

  def my_count(arg = nil)
    counter = 0
    case
    when block_given? then my_each { |item| counter += 1 if yield(item) == true }

    when arg.nil? then my_each { counter += 1 }

    else my_each { |item| counter += 1 if item == arg }

    end
    counter
  end
end
