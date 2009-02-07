require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReserveBoard do
  before(:each) do
    @target = []
    @target.extend ReserveBoard
  end

  describe "when setup" do
    it "should clear the target" do
      @target.should_receive(:clear)
      @target.setup
    end
  end

  describe "when asked for its tiles" do
    before(:each) do
      @tiles = []
      @slots = {}
      4.times do |i|
        tile = mock("tile #{i}")
        slot = mock("slot #{i}", :tile => tile)
        @tiles << tile
        @slots[tile] = slot
        @target << slot
      end
    end

    it "should get the tile from each link" do
      @slots.each do |tile,slot|
        slot.should_receive(:tile).once
      end
      @target.tiles
    end

    it "should return the tiles" do
      @target.tiles.should eql(@tiles)
    end
  end

  describe "when adding tiles" do
    before(:each) do
      @tiles = []
      3.times do |i|
        @tiles << mock("tile #{i}")
      end
    end

    it "should create a link for each tile" do
      @tiles.each do |tile|
        @target.should_receive(:create).with(:tile => tile)
      end
      @target.add_tiles(*@tiles)
    end
  end
end
