require 'spec_helper'
require './lib/enumerable'

RSpec.describe Enumerable do
  describe '#my_each' do
    it 'returns each array element as it is' do
      expect([1, 2, 3, 4].my_each { |num| num }).to eq([1, 2, 3, 4])
    end

    it 'should not return an element that was not in the array' do
      expect([1, 2, 3, 4, 5].my_each { |num| num }).to_not eq([1, 2, 3, 4, 5, 6])
    end

    it 'returns Enumerator if no block is given' do
      expect([1, 6, 7, 4].my_each.class).to eql(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'should return each element of array and index' do
      hash = {}
      %w[cat dog wombat fox].my_each_with_index { |item, index| hash[item] = index }
      expect(hash).to eql('cat' => 0, 'dog' => 1, 'wombat' => 2, 'fox' => 3)
    end

    it 'should return each element times its index' do
      array = []
      [1, 2, 3, 4].my_each_with_index { |ele, idx| array << ele * idx }
      expect(array).to eql([0, 2, 6, 12])
    end

    it 'returns Enumerator if no block is given' do
      expect([1, 6, 7, 4].my_each_with_index.class).to eql(Enumerator)
    end
  end

  describe '#my_select' do
    it 'should Returns an array containing all elements for which the given block returns a true value' do
      array = []
      (1..10).my_select do |i|
        array << i if i % 3 == 0
      end
      expect(array).to eql([3, 6, 9])
    end

    it 'should return all elements that are even in the array' do
      expect([1, 2, 3, 4, 5].my_select(&:even?)).to eql([2, 4])
    end

    it 'returns Enumerator if no block is given' do
      expect([1, 2, 3, 4].my_select.class).to eql(Enumerator)
    end
  end

  describe '#my_all' do
    it 'should return true if the block passed is not false or nil' do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 3 }).to eql(true)
    end

    it 'should return false if the block passed is not true' do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 4 }).to eql(false)
    end

    it 'should return true if the Regexp passed is matching' do
      expect(%w[ant bear cat].my_all?(/a/)).to eql(true)
    end

    it 'should return false if the Regexp passed is not matching' do
      expect(%w[ant bear cat].my_all?(/t/)).to eql(false)
    end

    it 'should return true when given an empty array' do
      expect([].my_all?).to eql(true)
    end

    it 'should return false if nil is present inside array ' do
      expect([nil, true, 'cat'].my_all?).to eql(false)
    end
  end

  describe '#my_any?' do
    it 'should return true if the block passed is not false or nil' do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 3 }).to eql(true)
    end

    it 'should return true if any element match the block passed is not false or nil' do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 4 }).to eql(true)
    end

    it 'should return true if any element match the Regexp passed' do
      expect(%w[ant bear cat].my_any?(/a/)).to eql(true)
    end

    it 'should return true if the Regexp passed is not matching' do
      expect(%w[ant bear cat].my_any?(/t/)).to eql(true)
    end

    it 'should return false when given an empty array' do
      expect([].my_any?).to eql(false)
    end

    it 'should return false if any element is not nil inside array ' do
      expect([nil, true, 'cat'].my_any?).to eql(true)
    end
  end

  describe '#my_none?' do
    it 'should return true if the block passed is not true' do
      expect(%w[ant bear cat].my_none? { |word| word.length == 5 }).to eql(true)
    end

    it 'should return false if any element match the block passed is not false or nil' do
      expect(%w[ant bear cat].my_none? { |word| word.length >= 4 }).to eql(false)
    end

    it 'should return false if any element match the Regexp passed' do
      expect(%w[ant bear cat].my_none?(/a/)).to eql(false)
    end

    it 'should return false if the Regexp passed is not matching' do
      expect(%w[ant bear cat].my_none?(/t/)).to eql(false)
    end

    it 'should return true when given an empty array' do
      expect([].my_none?).to eql(true)
    end

    it 'should return false if any element is true inside array ' do
      expect([nil, true, 'cat'].my_none?).to eql(false)
    end

    it 'should return true if elements are falsy inside array ' do
      expect([nil, false].my_none?).to eql(true)
    end
  end

  describe '#my_count' do
    array = [1, 2, 4, 2]
    it 'should return of items in the array when used with no arguments' do
      expect(array.my_count).to eql(4)
    end
    it 'should return the number of items equal to argument given' do
      expect(array.my_count(2)).to eql(2)
    end
    it 'should return the number of items thats yields true to the block given' do
      expect(array.my_count(&:even?)).to eql(3)
    end
  end

  describe '#my_map' do
    it 'should return a new array with results from given block' do
      expect([1, 2, 3, 4, 5].my_map { |i| i - 1 }).to eql([0, 1, 2, 3, 4])
    end

    it 'should return a new array from a Range with results from given block' do
      expect((1..4).my_map { |i| i * 2 }).to eql([2, 4, 6, 8])
    end

    it 'should return a new array with execution from a proc' do
      new_proc = proc { |n| n * n }
      expect([1, 2, 3, 4].my_map(&new_proc)).to eql([1, 4, 9, 16])
    end
  end

  describe '#my_inject' do
    describe 'when given a symbol as a parameter that defines an operator' do
      it 'should return the sum of all array numbers' do
        expect([1, 2, 3, 4].my_inject(:+)).to eql(10)
      end

      it 'should return the sum of all Range numbers' do
        expect((5..10).my_inject(:+)).to eql(45)
      end

      it 'should return the value of numbers with given 2 params one as initial other as a symbol of operator' do
        expect((5..10).my_inject(1, :*)).to eql(151_200)
      end
    end

    describe 'when a block is provided and with a parameter' do
      it 'should take 1st item and be the accumulator or set accum(1) and mulltiply all' do
        expect((5..10).my_inject(1) { |prod, n| prod * n }).to eql(151_200)
      end

      it 'should return the sum of array element' do
        expect([1, 2, 3, 4].my_inject { |acc, n| acc + n }).to eql(10)
      end
    end
  end

  describe '#multiply_els' do
    it 'should take an array as a param and multiply its elements' do
      array = [2, 5, 4]
      expect(multiply_els(array)).to eql(40)
    end
  end
end
