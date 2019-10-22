require 'oystercard'

describe Oystercard do
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }
  context '#balance' do
    it 'has an initial balance of 0' do
      expect(subject.balance).to eq (0)
    end
  end

  context '#top_up' do
    it 'tops up the balance by the top up amount' do
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

    it 'raises an error if the max balance has been reached' do
      max_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(max_balance)
      expect{ subject.top_up(1) }.to raise_error "max balance of #{max_balance} reached"
    end
  end

  context '#in_journey?' do
    it 'is intially not in a journey' do
      expect(subject).not_to be_in_journey
    end

    it 'initializes with no journies' do
      expect(subject.journies).to be_empty
    end

    it 'touching in and out creates 1 journey (an entry coupled with an exit station)' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journies.length).to eq 2
    end
  end

  context '#touch_in' do
    it 'touching in initiates a journey' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end

    it 'raises error when balance is less than £1' do
      expect { subject.touch_in(entry_station) }.to raise_error 'balance is less than £1'
    end

    it 'remembers the entry station' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.journies[:entry_station]).to eq entry_station
    end
  end

  context '#touch_out' do
    it 'touching out ends a journey' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end

    it 'reduces balance by the minimum fare (£1) when touching out' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect { subject.touch_out(exit_station) }.to change { subject.balance }.by -(Oystercard::MINIMUM_FARE)
    end

    it 'remembers exit station' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journies[:exit_station]).to eq exit_station
    end
  end
end
