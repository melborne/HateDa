
class Date
  def before?(date)
    comp(date) == -1
  end

  def after?(date)
    comp(date) == 1
  end

  def sameday?(date)
    comp(date) == 0
  end
  
  alias _between? between?
  def between?(min, max)
    min, max = [min, max].map { |d| Date.parse d }
    _between?(min, max)
  end
  private
  def comp(date)
    self <=> Date.parse(date)
  end
end
