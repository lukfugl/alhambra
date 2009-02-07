require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Game do
  before(:each) do
    @game = Game.new
  end

  describe "when setup" do
    before(:each) do
      @building_supply = mock("building supply", :setup => nil)
      @currency_supply = mock("currency supply", :setup => nil, :insert_scoring_cards => nil)
      @building_market = mock("building market", :setup => nil, :replenish => nil)
      @currency_market = mock("currency market", :setup => nil, :replenish => nil)

      @seats = (1..6).map do |i|
        mock("seat #{i}", :player => nil, :setup => nil, :destroy => nil)
      end

      @active_seats = @seats[2..4]
      @active_seats.each_with_index do |seat,i|
        seat.stub!(:player).and_return(mock("player #{i}"))
        @game.stub!(:rank_seat).with(seat).and_return(i)
      end
      @first_seat = @active_seats.first
      @inactive_seats = @seats - @active_seats

      @game.stub!(:building_supply).and_return(@building_supply)
      @game.stub!(:currency_supply).and_return(@currency_supply)
      @game.stub!(:building_market).and_return(@building_market)
      @game.stub!(:currency_market).and_return(@currency_market)
      @game.stub!(:seats).and_return(@seats)
      @game.stub!(:deal_hand)
      @game.stub!(:new_turn)
    end

    it "should setup the building supply" do
      @building_supply.should_receive(:setup).once
      @game.setup
    end

    it "should setup the currency supply" do
      @currency_supply.should_receive(:setup).once
      @game.setup
    end

    it "should setup the building market" do
      @building_market.should_receive(:setup).once
      @game.setup
    end

    it "should setup the currency market" do
      @currency_market.should_receive(:setup).once
      @game.setup
    end

    it "should setup each active seat" do
      @active_seats.each do |seat|
        seat.should_receive(:setup).once
        seat.should_not_receive(:destroy)
      end
      @game.setup
    end

    it "should deal a hand to each active seat" do
      @active_seats.each do |seat|
        @game.should_receive(:deal_hand).with(seat)
      end
      @game.setup
    end

    it "should destroy each inactive seat" do
      @inactive_seats.each do |seat|
        seat.should_receive(:destroy)
        seat.should_not_receive(:setup)
      end
      @game.setup
    end

    it "should replenish the building market from the building supply" do
      @building_market.should_receive(:replenish).with(@building_supply)
      @game.setup
    end

    it "should replenish the currency market from the currency supply" do
      @building_market.should_receive(:replenish).with(@building_supply)
      @game.setup
    end

    it "should insert the scoring cards into the currency supply" do
      @currency_supply.should_receive(:insert_scoring_cards)
      @game.setup
    end

    it "should rank each active seat to determine the first player" do
      @active_seats.each_with_index do |seat,i|
        @game.should_receive(:rank_seat).with(seat)
      end
      @game.setup
    end

    it "should start the first player's turn" do
      @game.should_receive(:new_turn).with(@first_seat)
      @game.setup
    end

    it "should save all the changes" do
      @game.should_receive(:save)
      @game.setup
    end
  end

  describe "when dealing a hand" do
    before(:each) do
      @currency_supply = mock("currency supply")
      @game.stub!(:currency_supply).and_return(@currency_supply)

      @hand = mock("hand")
      @seat = mock("seat", :hand => @hand)
      @hand.stub!(:value).and_return(0, 8, 14, 17, 22)

      @cards = (1..4).map{ |i| mock("card #{i}") }
      @currency_supply.stub!(:draw).and_return(*@cards)

      Event::CardsTaken.stub!(:create)
    end

    it "should draw cards until the hand value is at least 20" do
      @currency_supply.should_receive(:draw).exactly(4).times
      @game.deal_hand(@seat)
    end

    it "should create a CardsTaken event for each card drawn" do
      @cards.each do |card|
        Event::CardsTaken.should_receive(:create).with(:seat => @seat, :cards => [card])
      end
      @game.deal_hand(@seat)
    end
  end

  describe "when ranking a seat" do
    before(:each) do
      @hand = mock("hand", :size => 4, :value => 22)
      @seat = mock("seat", :hand => @hand)
    end

    it "should consider the hand size" do
      @hand.should_receive(:size)
      @game.rank_seat(@seat)
    end

    it "should consider the hand value" do
      @hand.should_receive(:value)
      @game.rank_seat(@seat)
    end
  end

  describe "when comparing seat rankings" do
    before(:each) do
      @hand1 = mock("hand 1", :size => 5, :value => 22)
      @hand2 = mock("hand 2", :size => 4, :value => 22)
      @hand3 = mock("hand 3", :size => 4, :value => 21)
      @seat1 = mock("seat 1", :hand => @hand1)
      @seat2 = mock("seat 2", :hand => @hand2)
      @seat3 = mock("seat 3", :hand => @hand3)
    end

    it "should choose by hand size first" do
      rank1 = @game.rank_seat(@seat1)
      rank2 = @game.rank_seat(@seat2)
      (rank1 <=> rank2).should equal(1)
    end

    it "should choose by hand value if hand size is the same" do
      rank1 = @game.rank_seat(@seat2)
      rank2 = @game.rank_seat(@seat3)
      (rank1 <=> rank2).should equal(1)
    end

    it "should choose randomly if hand size and value are the same" do
      @game.should_receive(:rand).and_return(0.6, 0.4)
      rank1 = @game.rank_seat(@seat3)
      rank2 = @game.rank_seat(@seat3)
      (rank1 <=> rank2).should equal(1)
    end
  end

  describe "when starting a new turn" do
    before(:each) do
      @seat = mock("seat")
      Event::NewTurn.stub!(:create)
    end

    it "should create a NewTurn event for the seat" do
      Event::NewTurn.should_receive(:create).with(:seat => @seat)
      @game.new_turn(@seat)
    end
  end
end
