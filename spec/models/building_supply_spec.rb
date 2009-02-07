require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildingSupply do
  before(:each) do
    @target = mock("target", :null_object => true)
    @target.extend BuildingSupply
  end

  describe "when setup" do
    before(:each) do
      @tiles = []
      @tiles << mock("tile1")
      @tiles << mock("tile2")
      Tile.stub!(:find).with(:all, anything()).and_return(@tiles)
      Event::BuildingSupplyShuffled.stub!(:create)

      @game = mock("game")
      @size = mock("size")
      @target.stub!(:game).and_return(@game)
      @target.stub!(:size).and_return(@size)
    end

    it "should clear the target" do
      @target.should_receive(:clear)
      @target.setup
    end

    it "should get the set of default tiles" do
      Tile.should_receive(:find).with(:all, :conditions => "building_type <> 'fountain'")
      @target.setup
    end

    it "should add each tile to the target" do
      @tiles.each do |tile|
        @target.should_receive(:build).once.with(hash_including(:tile => tile))
      end
      @target.setup
    end

    it "should create a BuildingSupplyShuffled event with the game and the tile count" do
      Event::BuildingSupplyShuffled.should_receive(:create).with(:game => @game, :size => @size)
      @target.setup
    end
  end

  describe "when a tile is drawn" do
    it "should look at the first tile" do
      @target.should_receive(:shift).once
      @target.draw
    end

    describe "but there are no tiles available" do
      before(:each) do
        @target.stub!(:shift).and_return(nil)
      end

      it "should return nil" do
        @target.draw.should be_nil
      end
    end

    describe "and there are tiles available" do
      before(:each) do
        @tile = mock("tile")
        @link = mock("link", :tile => @tile)
        @link.stub!(:destroy)
        @target.stub!(:shift).and_return(@link)
      end

      it "should return the first tile" do
        @target.draw.should equal(@tile)
      end

      it "should destroy the link between that tile and the target" do
        @link.should_receive(:destroy)
        @target.draw
      end
    end
  end

  describe "when the tiles are asked for" do
    before(:each) do
      # need map to work, so we'll just use an array this time
      @target = []
      @target.extend BuildingSupply

      @tiles = []
      (1..3).each do |i|
        tile = mock("tile #{i}")
        @tiles << tile
        @target << mock("link #{i}", :tile => tile)
      end
    end

    it "should get the tile from each link" do
      @target.each do |link|
        link.should_receive(:tile)
      end
      @target.tiles
    end

    it "should return the tiles" do
      @target.tiles.should eql(@tiles)
    end
  end
end
