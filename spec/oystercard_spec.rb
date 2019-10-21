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
end
