class Horse
  def initialize(n)
    @num = n
    @pos = 0
  end

  def step
    @pos += rand(5..15)
  end

  def num
    @num
  end

  def win?
    @pos >= 1000
  end

  def reset
    @pos = 0
  end
end
