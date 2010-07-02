require File.expand_path(File.dirname(__FILE__) + "/../lib/augmented_array")
require File.dirname(__FILE__) + '/spec_helper'

describe Array do
    
  before(:each) do
    @my_array = [1,2,3,4,5,nil,6,7,8,9,10,nil]
  end

  it "should return count of nil items in the array " do
    @my_array.nilitems.should == 2
    [].nilitems.should == 0
    [1,2,3].nilitems.should == 0
  end
  
  it "should return the sum of all elements in an integer or float array " do
    @my_array.sum.should == 55
    @my_array << 3.5
    @my_array.sum == 58.5
  end
  
  it "should throw Runtime error if any of the array elements is other than integer or float" do
    @my_array << "test"
    lambda {@my_array.sum}.should raise_error(RuntimeError, 'The array should be either an integer or float array')
  end
  
  it "should return the middle element with odd number of elements in the array" do
    [1,2,3,4,5].middle.should == 3
  end
  
  it "should return array of the middle 2 elements with even number of elements in the array" do
    @my_array.middle.should == [nil,6]
    [1,2,3,4].middle.should == [2,3]
  end

  it "should return the single element as middle element with one element array" do
    [1].middle.should == 1
  end
  
  it "should return nil if middle is invoked on an empty array" do
    [].middle.should be_nil
  end
  
  it "should return array of hashes with element as key and its class as value when describe is invoked on an array" do
    ary_desc = [1,1.0,"test",{:key => "value"}].describe
    ary_desc.first.should == {1=>'Fixnum'}
    ary_desc[1].should == {1.0=>'Float'}
    ary_desc[2].should == {'test'=>'String'}
    ary_desc[3].has_value?('Hash')
  end
  
  it "should return a new array by splitting the array into arrays of int divisor elements each if number of elements are completely divisible by divisor" do
    ary_div = @my_array / 3
    ary_div.size.should == 4
    ary_div.first.should == [1,2,3]
    ary_div.last.should == [9,10,nil]
  end
  
  it "should return a new array by splitting the array into arrays of int divisor elements each and remaining elements if number of elements are not completely divisible by divisor" do
    ary_div = @my_array / 5
    ary_div.size.should == 3
    ary_div.first.should == [1,2,3,4,5]
    ary_div.last.should == [10,nil]
  end
  
  it "should set the value of the first element of the array when first= invoked on the array" do
    @my_array.first = 20
    @my_array.first.should == 20
    ary = []
    ary.first = 10
    ary.first.should == 10
  end
  
 it "should set the value of the last element of the array when last= invoked on the array" do
    @my_array.last = 10
    @my_array.last.should == 10
    ary = []
    ary.last = 5
    ary.last.should == 5
  end
  
  it "should set and access the 2nd to 10th elements with method invocations like second, third upto tenth on the array" do
    @my_array.second = 2
    @my_array.second.should == 2
    @my_array.third = 3
    @my_array.third.should == 3
    @my_array.fourth = 4
    @my_array.fourth.should == 4
    @my_array.fifth = 5
    @my_array.fifth.should == 5
    @my_array.sixth = 6
    @my_array.sixth.should == 6
    @my_array.seventh = 7
    @my_array.seventh.should == 7
    @my_array.eighth = 8
    @my_array.eighth.should == 8
    @my_array.ninth = 9
    @my_array.ninth.should == 9
    @my_array.tenth = 10
    @my_array.tenth.should == 10
  end
  
  it "should collect alternate elements in different array and return array of those arrays" do
    new_ary = @my_array.alternate
    new_ary.size.should == 2
    new_ary.first.size.should == 6
    new_ary.second.size.should == 6
    @my_array.size.should == 12
  end
  
  it "should collect alternate elements in different array and modify the orignal array by adding those arrays" do
    @my_array.alternate!.size.should == 2
    @my_array.size.should == 2
    @my_array.first.size.should == 6
    @my_array.second.size.should == 6
  end
  
  it "should return empty array if alternate is invoked on an empty array" do
    [].alternate.size.should == 0
    [].alternate!.size.should == 0
  end
  
  it "should return an array with array consisting of one element if alternate is invoked on a single element array" do
    [1].alternate.size.should == 1
    [1].alternate!.first.first == 1
  end
  
  it "should set and retrieve array value at the specified positive index as if the index was its attribute" do
    ary = [1,2,3,4,5]
    ary._0 = 20
    ary._0.should == 20 
    ary._1 = 10
    ary._1.should == 10
    ary._7 = 30
    ary.size.should == 8
    ary._7.should == 30
    ary._6.should be_nil
  end
  
  it "should throw NoMethodError while setting and getting the array value with wrong index as an attribute on the array" do
    lambda {@my_array._abcd}.should raise_error(NoMethodError)
    lambda {@my_array._1abc}.should raise_error(NoMethodError)
    lambda {@my_array.t12}.should raise_error(NoMethodError)
    lambda {@my_array.s23}.should raise_error(NoMethodError)
  end
  
  
  it "should call block once with traversing the array elements incremented by positive step, passing that array element as a parameter" do
    ary = [1,2,3,4,5,6]
    new_ary = []
    ary.step_by(2){|x| new_ary << x}
    new_ary.should == [1,3,5]
  end
  
  it "should call block once with traversing all the elements similar to each method" do
    ary = [1,2,3,4,5,6]
    new_ary = []
    ary.step_by(1) {|x| new_ary << x}
    new_ary.should == [1,2,3,4,5,6]
    new_ary.last.should == 6
  end 

  it "should return only first element if step mentioned is greater that size of the array" do
    ary = [1,2,3,4,5,6]
    new_ary = []
    ary.step_by(10) {|x| new_ary << x}
    new_ary.should == [1]
  end     
   
  it "should throw ArgumentError if the step mentioned is either zero or negative" do
    lambda{@my_array.step_by(0)}.should raise_error(ArgumentError, "Step can't be 0 or negative")
    lambda{@my_array.step_by(-2)}.should raise_error(ArgumentError, "Step can't be 0 or negative")
  end
  
  it "should throw LocalJumpError if no block is provided" do
    lambda{@my_array.step_by(1)}.should raise_error(LocalJumpError, "no block given")
  end

end