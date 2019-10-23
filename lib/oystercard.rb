require_relative 'journey'

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  def initialize
    @journey = Journey.new
    @balance = 0
  end

  attr_reader :balance

  def top_up(amount)
    raise "max balance of #{MAXIMUM_BALANCE} reached" if max?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'balance is less than £1' if min?
    @journey.start_journey(entry_station)
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @journey.end_journey(exit_station)
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
