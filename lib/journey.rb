class Journey
  def initialize
    @journies = { :entry_stations => [], :exit_stations => [] }
  end

  PENTALTY_FARE = 6
  attr_reader :journies

  def in_journey?
    return !entry_eq_exit? unless @journies[:entry_stations].empty? && @journies[:exit_stations].empty?
    return false
  end

  def start_journey(entry_station)
    @journies[:entry_stations].push(entry_station)
  end

  def end_journey(exit_station)
    @journies[:exit_stations].push(exit_station)
  end

  def fare
    unless in_journey?
      return Oystercard::MINIMUM_FARE
    else
      update_stations
      return PENTALTY_FARE
    end
  end

  private

  def update_stations
    get_counts

    if @exit_count - @entry_count == 1
      @journies[:entry_stations][@entry_count] = 'No entry station recorded'
    elsif @entry_count - @exit_count == 2
      @journies[:exit_stations][@entry_count - 2] = 'No exit station recorded'
    end
  end

  def entry_eq_exit?
    @journies[:entry_stations].count == @journies[:exit_stations].count
  end

  def get_counts
    @entry_count = @journies[:entry_stations].count
    @exit_count = @journies[:exit_stations].count
  end
end
