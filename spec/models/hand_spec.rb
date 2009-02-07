require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hand do
  before(:each) do
    @target = []
    @target.extend Hand
  end

  describe "when setup" do
    it "should clear the target" do
      @target.should_receive(:clear)
      @target.setup
    end
  end

  describe "when asked for its cards" do
    before(:each) do
      @cards = []
      @slots = {}
      4.times do |i|
        card = mock("card #{i}")
        slot = mock("slot #{i}", :card => card)
        @cards << card
        @slots[card] = slot
        @target << slot
      end
    end

    it "should get the card from each link" do
      @slots.each do |card,slot|
        slot.should_receive(:card).once
      end
      @target.cards
    end

    it "should return the cards" do
      @target.cards.should eql(@cards)
    end
  end

  describe "when asked for its value" do
    before(:each) do
      @cards = []
      @slots = {}
      (1..4).each do |i|
        card = mock("card #{i}", :value => i)
        slot = mock("slot #{i}", :card => card)
        @cards << card
        @slots[card] = slot
        @target << slot
      end
    end

    it "should look at each card's value" do
      @slots.each do |card,slot|
        slot.should_receive(:card).once
        card.should_receive(:value).once
      end
      @target.value
    end

    it "should return the total value" do
      @target.value.should equal(10)
    end
  end

  describe "when adding cards" do
    before(:each) do
      @cards = []
      3.times do |i|
        @cards << mock("card #{i}")
      end
    end

    it "should create a link for each card" do
      @cards.each do |card|
        @target.should_receive(:create).with(:card => card)
      end
      @target.add_cards(*@cards)
    end
  end
end
