class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  def initialize
    @balance = 0
    @journies = {}
    @in_journey = false
  end
  attr_reader :balance
  attr_reader :journies

  def top_up(amount)
    raise "max balance of #{MAXIMUM_BALANCE} reached" if max?(amount)
    @balance += amount
  end

  def in_journey?
    return true if @journies.length % 2 == 1
    return false
  end

  def touch_in(entry_station)
    raise 'balance is less than £1' if min?
    @journies[:entry_station] = entry_station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @journies[:exit_station] = exit_station
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
