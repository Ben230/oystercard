class Journey
  def initialize
    @journies = {}
    @in_journey = false
  end
  attr_reader :journies

  def in_journey?
    return true if @journies.length % 2 == 1
    return false
  end

  def start_journey(entry_station)
    @journies[:entry_station] = entry_station
  end

  def end_journey(exit_station)
    @journies[:exit_station] = exit_station
  end
end
