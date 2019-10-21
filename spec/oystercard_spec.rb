require 'oystercard'

describe Oystercard do
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

    it 'touching in initiates a journey' do
      subject.top_up(10)
      subject.touch_in
      expect(subject).to be_in_journey
    end

    it 'touching out ends a journey' do
      subject.top_up(10)
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it 'raises error when balance is less than £1' do
      expect { subject.touch_in }.to raise_error 'balance is less than £1'
    end

    it 'reduces balance by the minimum fare (£1) when touching out' do
      subject.top_up(10)
      subject.touch_in
      expect { subject.touch_out }.to change { subject.balance }.by -(Oystercard::MINIMUM_FARE)
    end
  end
end
