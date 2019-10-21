class Oystercard
  MAXIMUM_BALANCE = 90
  def initialize
    @balance = 0
  end
  attr_reader :balance

  def top_up(amount)
    raise "max balance of #{MAXIMUM_BALANCE} reached" if max?(amount)
    @balance += amount
  end

  private

  def max?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end
end
