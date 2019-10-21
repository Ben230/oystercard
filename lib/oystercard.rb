class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  def initialize
    @balance = 0
    @in_journey = false
  end
  attr_reader :balance

  def top_up(amount)
    raise "max balance of #{MAXIMUM_BALANCE} reached" if max?(amount)
    @balance += amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    raise 'balance is less than £1' if min?
    @in_journey = true
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @in_journey = false
  end

  private

  def max?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def min?
    @balance < MINIMUM_FARE
  end

  def deduct(fare)
    @balance -= fare
  end
end
