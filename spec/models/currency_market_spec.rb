require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrencyMarket do
  before(:each) do
    @target = mock("target")
    @target.extend CurrencyMarket
  end

  describe "when setup" do
    it "should clear the target" do
      @target.should_receive(:clear)
      @target.setup
    end
  end

  describe "when replenished" do
    before(:each) do
      @supply = mock("supply")
      @supply.stub!(:draw)
      Event::CurrencyMarketStocked.stub!(:create)
    end

    it "should check how many cards are in the target" do
      @target.should_receive(:size).and_return(4)
      @target.replenish(@supply)
    end

    describe "while full" do
      before(:each) do
        @target.stub!(:size).and_return(4)
      end

      it "should not draw any cards from the supply" do
        @supply.should_not_receive(:draw)
        @target.replenish(@supply)
      end

      it "should not create any events" do
        Event::CurrencyMarketStocked.should_not_receive(:create)
        @target.replenish(@supply)
      end
    end

    describe "while not full" do
      before(:each) do
        @target.stub!(:size).and_return(2, 3, 4)
        @card1 = mock("card 1")
        @card2 = mock("card 2")
        @supply.stub!(:draw).and_return(@card1, @card2)
      end

      it "should draw cards from the supply" do
        @supply.should_receive(:draw).exactly(2).times
        @target.replenish(@supply)
      end

      it "should create BuildingMarketStocked events for the drawn cards" do
        Event::CurrencyMarketStocked.should_receive(:create).once.with(:currency_market => @target, :card => @card1)
        Event::CurrencyMarketStocked.should_receive(:create).once.with(:currency_market => @target, :card => @card2)
        @target.replenish(@supply)
      end
    end
  end

  describe "when cards are taken" do
    before(:each) do
      # need detect to work, so we'll just use an array this time
      @target = []
      @target.extend CurrencyMarket

      # populate the market
      @cards = []
      @slots = {}
      4.times do |i|
        card = mock("card #{i}", :null_object => true)
        slot = mock("slot", :card => card)
        @cards << card
        @target << slot
        @slots[card] = slot
      end

      @taken_cards = mock("cards", :include? => false)
    end

    it "should check the card in each slot" do
      @slots.each do |card,slot|
        slot.should_receive(:card)
      end
      @target.take(@taken_cards)
    end

    describe "but the card is not there" do
      it "should not do anything to the slots" do
        # the slots are not null_objects, so any call would cause a failure
        @target.take(@taken_cards)
      end

      it "should return an empty array" do
        @target.take(@taken_cards).should be_empty
      end
    end

    describe "and the card is there" do
      before(:each) do
        @card = @cards[0]
        @slot = @slots[@card]
        @slot.stub!(:destroy)
        @taken_cards.stub!(:include?).with(@card).and_return(true)
      end

      it "should destroy the link" do
        @slot.should_receive(:destroy)
        @target.take(@taken_cards)
      end

      it "should remove the link from the target" do
        @target.should_receive(:delete).with(@slot)
        @target.take(@taken_cards)
      end

      it "should return the card" do
        @target.take(@taken_cards).should eql([@card])
      end
    end
  end
end
