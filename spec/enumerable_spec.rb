require 'spec_helper'
require './lib/enumerable'

RSpec.describe Enumerable do
    describe "#my_each" do
        it 'should return each array element as it is' do
            expect([1,2,3,4].my_each {|num| num}).to eq([1,2,3,4])
        end

        it 'should not return an element that was not in the array' do
            expect([1,2,3,4,5].my_each {|num| num}).to_not eq([1,2,3,4,5,6])  
        end

        it 'returns Enumerator if no block is given' do
            expect([1, 6, 7, 4].my_each.class).to eql(Enumerator)
          end
          
    end

    describe "#my_each_with_index" do
        it 'should return each element of array and index' do
            hash = {}
        ['cat','dog','wombat','fox'].my_each_with_index { |item, index| hash[item] = index }
        expect(hash).to eql('cat' => 0, 'dog' => 1, 'wombat' => 2, 'fox' => 3)
        end

        it 'should return each element times its index' do
            array = []
            [1,2,3,4].my_each_with_index {|ele,idx| array << ele * idx}
            expect(array).to eql([0,2,6,12])  
        end

        it 'returns Enumerator if no block is given' do
            expect([1, 6, 7, 4].my_each_with_index.class).to eql(Enumerator)
          end
    end

    describe "#my_select" do
        it 'should Returns an array containing all elements for which the given block returns a true value' do
            array = []
            (1..10).my_select do |i|
                if  i % 3 == 0
                     array << i
                end
            end
            expect(array).to eql([3,6,9]) 
        end

        it 'should return all elements that are even in the array' do
            expect([1,2,3,4,5].my_select {|num| num.even?}).to eql([2,4]) 
        end

        it 'returns Enumerator if no block is given' do
            expect([1, 2, 3, 4].my_select.class).to eql(Enumerator)
          end

    end
    
    describe "#my_all" do
        it 'should return true if the block passed is not false or nil' do
            expect(['ant','bear','cat'].my_all? {|word| word.length >= 3 }).to  eql(true)
        end

        it 'should return false if the block passed is not true' do
            expect(['ant','bear','cat'].my_all? {|word| word.length >= 4 }).to  eql(false)
        end

        it 'should return true if the Regexp passed is matching' do
            expect(['ant','bear','cat'].my_all?(/a/)).to  eql(true)
        end

        it 'should return false if the Regexp passed is not matching' do
            expect(['ant','bear','cat'].my_all?(/t/)).to  eql(false)
        end

        it 'should return true when given an empty array' do
            expect([].my_all?).to eql(true)
        end

        it 'should return false if nil is present inside array ' do
            expect([nil,true,'cat'].my_all?).to  eql(false)
        end
    end
    
    
end
