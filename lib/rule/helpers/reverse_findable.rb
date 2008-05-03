# Just like Array#find_index, but it searches from the right
#
# Example usage:
#
#   a = [:d, :a, :v, :i, :d, :j]
#   a.extend ReverseFindable
#   a.rfind_index { |i| i == :d }
#   => 4
#
module ReverseFindable
  
  def rfind_index(&b)
    i = self.reverse.find_index(&b)
    i ? self.length - 1 - i : nil
  end
  
end