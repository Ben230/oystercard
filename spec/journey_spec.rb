require 'journey'

describe Journey do
  let(:oystercard) { double(:oystercard) }
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }

  context 'initially' do
    it 'is intially not in a journey' do
      expect(subject).not_to be_in_journey
    end

    it 'initializes with no entry stations' do
      expect(subject.journies[:entry_stations]).to be_empty
    end

    it 'initializes with no exit stations' do
      expect(subject.journies[:exit_stations]).to be_empty
    end
  end

  context 'after touching in' do
    before { allow(oystercard).to receive(:touch_in).and_return subject.start_journey(entry_station) }

    it 'initiates a journey' do
      expect(subject).to be_in_journey
    end

    it 'remembers the entry station' do
      expect(subject.journies[:entry_stations][0]).to eq entry_station
    end

    it 'returns a penalty fare for no end station' do
      expect(subject.fare).to eq Journey::PENTALTY_FARE
    end
  end

  context 'after exclusively touching out' do
    before { allow(oystercard).to receive(:touch_out).and_return subject.end_journey(exit_station) }

    it 'returns a penalty fare' do
      expect(subject.fare).to eq Journey::PENTALTY_FARE
    end

    it 'has equal entry stations to exit stations' do
      subject.fare
      expect(subject.journies[:entry_stations][0]).to eq 'No entry station recorded'
    end
  end

  context 'after touching in and out' do
    before do
      allow(oystercard).to receive(:touch_in).and_return subject.start_journey(entry_station)
      allow(oystercard).to receive(:touch_out).and_return subject.end_journey(exit_station)
    end

    it 'creates 1 entry station' do
      expect(subject.journies[:entry_stations].count).to eq 1
    end

    it 'creates 1 exit station' do
      expect(subject.journies[:exit_stations].count).to eq 1
    end

    it 'ends a journey' do
      expect(subject).not_to be_in_journey
    end

    it 'remembers exit station' do
      expect(subject.journies[:exit_stations][0]).to eq exit_station
    end

    it 'returns minimum fare' do
      expect(subject.fare).to eq Oystercard::MINIMUM_FARE
    end

    it 'returns a penalty fare if no end station, after a completed journey case' do
      allow(oystercard).to receive(:touch_in).and_return subject.start_journey(entry_station)
      expect(subject.fare).to eq Journey::PENTALTY_FARE
    end

    it 'touching in initiates a journey, after a completed journey case' do
      allow(oystercard).to receive(:touch_in).and_return subject.start_journey(entry_station)
      expect(subject).to be_in_journey
    end
  end

  context 'after touching in twice' do
    before do
      allow(oystercard).to receive(:touch_in).and_return subject.start_journey(entry_station)
      allow(oystercard).to receive(:touch_in).and_return subject.start_journey(entry_station)
    end

    it 'returns a penalty fare' do
      expect(subject.fare).to eq Journey::PENTALTY_FARE
    end

    it 'fills in the empty exit station' do
      subject.fare
      expect(subject.journies[:exit_stations][0]).to eq 'No exit station recorded'
    end

    it 'touches out charges the minimum fare' do
      subject.fare
      allow(oystercard).to receive(:touch_out).and_return subject.end_journey(exit_station)
      expect(subject.fare).to eq Oystercard::MINIMUM_FARE
    end
  end

end
