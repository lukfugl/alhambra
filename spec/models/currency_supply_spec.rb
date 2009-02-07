require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CurrencySupply do
  before(:each) do
    @target = mock("target", :null_object => true)
    @target.extend CurrencySupply
  end

  describe "when setup" do
    before(:each) do
      @cards = []
      @cards << mock("card1")
      @cards << mock("card2")
      Card.stub!(:find).with(:all, anything()).and_return(@cards)
      Event::CurrencySupplyShuffled.stub!(:create)

      @game = mock("game")
      @size = mock("size")
      @target.stub!(:game).and_return(@game)
      @target.stub!(:size).and_return(@size)
    end

    it "should clear the target" do
      @target.should_receive(:clear)
      @target.setup
    end

    it "should get the set of default cards" do
      Card.should_receive(:find).with(:all, :conditions => "currency <> 'scoring'")
      @target.setup
    end

    it "should add each card to the target" do
      @cards.each do |card|
        @target.should_receive(:build).once.with(hash_including(:card => card))
      end
      @target.setup
    end

    it "should create a CurrencySupplyShuffled event with the game and the card count" do
      Event::CurrencySupplyShuffled.should_receive(:create).with(:game => @game, :size => @size)
      @target.setup
    end
  end

  describe "when a card is drawn" do
    it "should look at the first card" do
      @target.should_receive(:shift).once
      @target.draw
    end

    describe "but there are no cards available" do
      before(:each) do
        @target.stub!(:shift).and_return(nil)
      end

      it "should return nil" do
        @target.draw.should be_nil
      end
    end

    describe "and there are cards available" do
      before(:each) do
        @card = mock("card")
        @link = mock("link", :card => @card)
        @link.stub!(:destroy)
        @target.stub!(:shift).and_return(@link)
      end

      it "should return the first card" do
        @target.draw.should equal(@card)
      end

      it "should destroy the link between that card and the target" do
        @link.should_receive(:destroy)
        @target.draw
      end
    end
  end

  describe "when the cards are asked for" do
    before(:each) do
      # need map to work, so we'll just use an array this time
      @target = []
      @target.extend CurrencySupply

      @cards = []
      (1..3).each do |i|
        card = mock("card #{i}")
        @cards << card
        @target << mock("link #{i}", :card => card)
      end
    end

    it "should get the card from each link" do
      @target.each do |link|
        link.should_receive(:card)
      end
      @target.cards
    end

    it "should return the cards" do
      @target.cards.should eql(@cards)
    end
  end
end
