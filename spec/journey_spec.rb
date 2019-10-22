require 'journey'
require 'oystercard'

describe Journey do
  let(:oystercard) { Oystercard.new }
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }

  it 'is intially not in a journey' do
    expect(subject).not_to be_in_journey
  end

  it 'initializes with no journies' do
    expect(subject.journies).to be_empty
  end

  it 'touching in and out creates 1 journey (an entry coupled with an exit station)' do
    oystercard.top_up(10)
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    expect(subject.journies.length).to eq 2
  end

  it 'touching in initiates a journey' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    expect(journey).to be_in_journey
  end

  it 'remembers the entry station' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    expect(subject.journies[:entry_station]).to eq entry_station
  end

  it 'touching out ends a journey' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject).not_to be_in_journey
  end

  it 'remembers exit station' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journies[:exit_station]).to eq exit_station
  end
end
