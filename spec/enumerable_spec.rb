require 'spec_helper'
require './lib/enumerable'

RSpec.describe Enumerable do
    describe "#my_each" do
        it 'should return each array element as it is' do
            expect([1,2,3,4].my_each {|num| p num}).to eq([1,2,3,4])
        end

        it 'should not return an element that was not in the array' do
            expect([1,2,3,4,5].my_each {|num| p num}).to_not eq([1,2,3,4,5,6])  
        end
          
    end
    
end
