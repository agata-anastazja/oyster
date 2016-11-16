require 'oystercard'

describe Oystercard do

  subject(:oyster) {described_class.new}


  context 'balance on card' do

    it 'has money on the card, its initial value is 0' do
      expect(oyster.balance).to eq 0
    end

    it 'responds to the balance method' do
      expect(oyster).to respond_to(:balance)
    end
  end

  context '#top_up' do

    it 'can do topping up' do
      expect(oyster).to respond_to(:top_up).with(1).argument
    end

    it 'the top up increases the amount on the card' do
      amount = 10
      expect(oyster.top_up(amount)).to eq(oyster.balance)
    end

    context 'maximum balance' do

      it 'raise error if we try to top of after the card reached the maximum' do
        oyster.top_up(90)
        expect{oyster.top_up(1)}.to raise_error('The card has reached its maximum, no more top up')
      end

    end
  end

  context 'deduct_money' do

    before(:each) do
      oyster.top_up(70)
      @amount = 1
    end

    it 'should respond to the deduct method' do
      expect(oyster).to respond_to(:deduct).with(@amount).argument
    end

    it 'should deduct money from the card and return new balance' do
      expect{oyster.deduct(@amount)}.to change{oyster.balance}.by(-@amount)
    end
  end

  context 'When checking the satus' do
    it "should return the status of the card" do
      expect(oyster.in_journey).to eq false
    end

    it "should change the status is true" do
      oyster.touch_in
      expect(oyster.in_journey).to eq true
    end

    it "should change the status is true" do
      oyster.touch_in
      oyster.touch_out
      expect(oyster.in_journey).to eq false
    end
    
  end
  context "raise error" do

    it "when trying to touch out without touching in" do
      message = "You can only touch out if you already touched in"
      expect{oyster.touch_out}.to raise_error message
    end

  end

end