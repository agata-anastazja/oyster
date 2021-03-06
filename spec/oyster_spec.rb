require 'oyster'




describe Oyster do
  subject(:card) {described_class.new}
  let(:station) {double(:station)}
  let(:station2) {double(:station)}

  describe "Balance" do
    it "should display zero when object is initialized" do
      expect(card.balance).to eq 0
    end

    context "when the balance exceeds its limits, should raise an error" do

      it "if there less balance then minimum journey fare, and we touch in" do
        card.top_up(0.5)
        message = "You're poor, go and top up"
        expect{card.touch_in(station)}.to raise_error(message)
      end

      it " if we add more than 90 to the balance" do
        message = "The limit for topping up is 90 pounds"
        expect{card.top_up(91)}.to raise_error(message)
      end

    end
  end

  describe "will change, " do
    before(:each) {card.top_up(10)}
    it "should add 10 to the balance" do
      expect(card.balance).to eq 10
    end
  end

  describe "When checking card status" do
    before(:each) {card.top_up(10)}
    it "should return nil as a default" do
      expect(card.entry_station).to eq nil
    end

    it "should return name of the start station when on journey" do
      card.touch_in(station)
      expect(card.entry_station).to eq station
    end

    it "should return nil when touching out" do
      card.touch_out(station)
      expect(card.entry_station).to eq nil
    end

    it "should deduct minimum fare from the balance when checking out" do
      card.touch_in(station)
      expect{card.touch_out(station)}.to change{card.balance}.by(-1)
    end

  end

  describe "To keep history of journeys" do
    before(:each) {card.top_up(10)}

    it "should take station as a variable when touching in" do
      expect(card).to respond_to(:touch_in).with(1).argument
    end

    it "should save the entry station" do

      card.touch_in(station)
      expect(card.entry_station).to eq station
    end

    it "should forget the entry station after check out" do
      card.touch_in(station)
      card.touch_out(station)
      expect(card.entry_station).to eq nil
    end

    it "should forget the exit station after storing the journey" do
      card.touch_out(station)
      expect(card.exit_station).to eq nil
    end

    it "should have an empty list of journeys by default" do
      expect(card.journeys).to be_empty
    end

    it "should store a journey" do
      card.touch_in(station)
      card.touch_out(station2)
      expect(card.journeys[station]).to eq station2
    end
  end

end
