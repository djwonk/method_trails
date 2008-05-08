class Pythagoras
  def hypotenuse(a, b)
    square_root(sum_of_squares(a, b))
  end
  def square_root(x)
    Math::sqrt(x)
  end
  def sum_of_squares(a, b)
    sum(square(a), square(b))
  end
  def sum(a, b)
    a + b
  end
  def square(x)
    multiply(x, x)
  end
  def multiply(a, b)
    a * b
  end
end
