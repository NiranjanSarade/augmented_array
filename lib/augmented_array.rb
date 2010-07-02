# 
# augmented_array.rb
# 
# The Ruby Array class is extended with some traversing methods and you will also be able to get and set the 
# individual array elements with indexes as of the indexes were attributes of an array.
#
 
Array.class_eval do
  
  Map = {:second => 1, :third => 2, :fourth => 3, :fifth => 4, :sixth => 5, :seventh => 6, :eighth => 7, :ninth => 8, :tenth => 9}
  
  # Returns array of hashes with element as key and its class as value
  #
  #  [1,1.0,"test",{:key => "value"}].describe   # =>  [{1=>"Fixnum"}, {1.0=>"Float"}, {"test"=>"String"}, {{:key=>"value"}=>"Hash"}]
  #  [1,2,3].describe     # =>  [{1=>"Fixnum"}, {2=>"Fixnum"}, {3=>"Fixnum"}]
  #  [[1,2],1].describe   # => [{[1, 2]=>"Array"}, {1=>"Fixnum"}]
  #  [].describe          # => []
  #
  def describe
    ary = []
    each do |element|
      ary << {element => element.class.to_s}
    end
    ary
  end  
  
  # Returns count of nil items in the array
  #
  #  [nil,1,2,nil,3].nilitems   # =>  2
  #  [1,2,3].nilitems           # => 0
  #  [].nilitems                # => 0
  #
  def nilitems
    size - nitems
  end
  
  # Returns the sum of all elements in an integer or float array
  #
  #  [1,2,3,4,5].sum     # => 15
  #  [1.1,2.3,4.56].sum  # => 7.96
  #  [1,2.5,5].sum       # => 8.5
  #  [].sum              # => nil
  #  [1,2,"test"].sum    # => The array should be either an integer or float array (RuntimeError)
  #
  def sum
    each do |element|
      unless element.nil? 
        if !element.kind_of?(Fixnum) and !element.kind_of?(Float)
          raise RuntimeError, "The array should be either an integer or float array"
        end
      end
    end  
    sum = 0
    self.inject {|sum, n| n = 0 if n.nil?; sum + n }
  end
  
  # Returns a new array by splitting the array into arrays of int divisor elements each
  # 
  # [1,2,3,4,5,6]/1      # => [[1], [2], [3], [4], [5], [6]]
  # [1,2,3,4,5,6]/2      # => [[1, 2], [3, 4], [5, 6]]
  # [1,2,3,4,5,6]/3      # => [[1, 2, 3], [4, 5, 6]]
  # [1,2,3,4,5,6]/4      # => [[1, 2, 3, 4], [5, 6]]
  # [1,2,3,4,5,6]/8      # => [[1, 2, 3, 4, 5, 6]]
  # []/2                 # => []
  # [1,2,3]/-2           # => Invalid argument -> -2 (ArgumentError)
  # [1,2,3]/0            # => Invalid argument -> 0 (ArgumentError)
  #
  def /(number)
      raise ArgumentError, "Invalid argument -> #{number.inspect}"  if !number.kind_of?(Fixnum) or number.zero? or (number < 0)
      divisor = number.to_i
      split, last, start, final_ary = size.div(divisor), size.modulo(divisor), 0, []
      split.times {
        final_ary << self[start, divisor]
        start += divisor
      }
      final_ary << self[start, last] unless last.zero?
      final_ary
  end

  # Returns middle or central element of the array
  # 
  # [1,2,3,4,5].middle      # => 3
  # [1,2,3,4].middle        # => [2, 3]
  # [1,2,3,4,5,6].middle    # => [3, 4]
  # [1].middle              # => 1
  # [].middle               # => nil
  #  
  def middle
      len = self.size
      return nil if len.zero?
      div = len.div(2)
      if len.modulo(2).zero?
        [self[div-1],self[div]] 
      else
        self[div]
      end
  end  
  
  # Sets value of the first element of the array
  # 
  # ary = [1,2,3]
  # ary.first = 20
  # ary.first       # => 20
  # ary = []
  # ary.first = 10
  # ary.first       # => 10
  #  
  def first= value
    self[0] = value
  end
  
  # Sets value of the last element of the array
  # 
  # ary = [1,2,3]
  # ary.last = 20
  # ary.last       # => 20
  # ary = []
  # ary.last = 10
  # ary.last       # => 10
  #  
  def last= value
    return self[size-1] = value if size > 0
    self[0] = value if size == 0
  end
  
  # Returns second last element of the array
  # 
  # [1,2,3,4,5].second_last      # => 4
  # [1].second_last              # => nil
  # [].second_last               # => nil
  #  
  def second_last
    return nil if (size-2) < 0
    self[size-2]
  end
  
  # Returns array of alternate elements collected in arrays
  # 
  # ary = [1,2,3,4,5]
  # ary.alternate           # => [[1, 3, 5], [2, 4]]
  # ary                     # => [1,2,3,4,5] 
  # [1,2,3,4].alternate     # => [[1, 3], [2, 4]]
  # [1,2].alternate         # => [[1], [2]]
  # [1].alternate           # => [[1]]
  # [].alternate            # => []
  #
  def alternate
    return [] if size.zero?
    return [[self[0]]] if size == 1       
    populate_alternate_arrays
  end  
  
  # Modifies the array by returning array of alternate elements collected in arrays
  # 
  # ary = [1,2,3,4,5]
  # ary.alternate!           # => [[1, 3, 5], [2, 4]]
  # ary                      # => [[1, 3, 5], [2, 4]]
  # [1,2,3,4].alternate!     # => [[1, 3], [2, 4]]
  # [1,2].alternate!         # => [[1], [2]]
  # [1].alternate!           # => [[1]]
  # [].alternate!            # => []
  # 
  def alternate!
    return self if size.zero?
    first = self[0]
    return self.clear << [first] if size == 1
    ary1, ary2 =  populate_alternate_arrays
    self.clear << ary1 << ary2
  end

  #  Returns block call once with iterating the array elements incremented by positive step, passing that array element as a parameter
  #  
  #  [1,2,3,4,5,6].step_by(2){|x| p x}  # => 1 3 5
  #  [1,2,3].step_by(1){|x| p x}        # => 1 2 3
  #  [1,2,3,4].step_by(6){|x| p x}      # => 1
  #  [1,2].step_by(0){|x| p x}          # => Step can't be 0 or negative (ArgumentError)
  #  [1,2].step_by(-1){|x| p x}         # => Step can't be 0 or negative (ArgumentError)
  #  [1.2].step_by(1)                   # => no block given (LocalJumpError)
  #  
  def step_by(n)
      raise ArgumentError, "Step can't be 0 or negative" if n.zero? or n < 0
      0.step(size-1,n) {|i| yield self[i]}
  end  
  
  # Sets and gets the 2nd to 10th elements with method invocations like second, third upto tenth on the array
  # Also, sets and retrieves array value at the specified positive index as if the index was its attribute
  #
  # ary = [1,2,3,4,5,6,7]
  # ary.second = 20
  # ary.third = 30
  # ary.fourth = 40
  # ary.fifth = 50
  # ary.sixth = 60
  # ary.seventh = 70
  # ary.eighth = 80
  # ary.ninth = 90
  # ary.tenth = 100
  # ary                # => [1, 20, 30, 40, 50, 60, 70, 80, 90, 100]
  # ary.second         # => 20
  # ary.third          # => 30
  # ary.tenth          # => 100
  # ary._0 = 25
  # ary._0             # => 25 # Similar to ary.at(0) or ary.fetch(0)
  # ary._1 = 10
  # ary._1             # => 10
  # ary._15 = 15
  # ary                # => [25, 10, 30, 40, 50, 60, 70, 80, 90, 100, nil, nil, nil, nil, nil, 15]
  # 
  # ary.t12            # => undefined method `t12'
  # ary._abcd          # => undefined method `_abcd' 
  # ary._1a            # => undefined method `_1a'
  # 
  # ary.each_index { |index|
  #    eval("p ary._#{index}")
  #  }
  #  
  #  ary.each_index { |index|
  #    eval("ary._#{index} = 10")  
  #  }
  #
  def method_missing(symbol, *args)
    key = symbol.to_s
    setter = symbol.to_s.chop.to_sym
    if Map.include?(symbol)
      self[Map[symbol]]
    elsif Map.include?(setter)
      self[Map[setter]] = args[0]
    elsif key[0,1] == '_' and key[-1,1] == "="  # only positive index
      self[key.chop[1..-1].to_i] = args[0]
    elsif key[0,1] == '_' and is_numeric?(key[1..-1])  # only positive index
      self[key[1..-1].to_i]
    else
      super
    end
  end
  
  private
  
  def populate_alternate_arrays 
    ary1, ary2 = [],[]
    each_index {|index| 
      if index.modulo(2).zero?
        ary1 << self[index]
      else
        ary2 << self[index]
      end
    }
    [ary1, ary2]    
  end
  
  def is_numeric?(s)
    s.to_i.to_s == s || s.to_f.to_s == s
  end
end

