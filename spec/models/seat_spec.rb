require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Seat do
  before(:each) do
    @seat = Seat.new
  end

  describe "when setup" do
    before(:each) do
      @alhambra = mock("alhambra")
      @alhambra.stub!(:setup)
      @seat.stub!(:alhambra).and_return(@alhambra)

      @reserve_board = mock("reserve_board")
      @reserve_board.stub!(:setup)
      @seat.stub!(:reserve_board).and_return(@reserve_board)

      @hand = mock("hand")
      @hand.stub!(:setup)
      @seat.stub!(:hand).and_return(@hand)
    end

    it "should setup the alhambra" do
      @alhambra.should_receive(:setup)
      @seat.setup
    end

    it "should setup the reserve board" do
      @reserve_board.should_receive(:setup)
      @seat.setup
    end

    it "should setup the hand" do
      @hand.should_receive(:setup)
      @seat.setup
    end
  end
end
