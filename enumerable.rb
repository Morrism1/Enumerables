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
end


