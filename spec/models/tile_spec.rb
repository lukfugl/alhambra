require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tile do
  describe "when asked for its walls" do
    before(:each) do
      @tile = Tile.new
    end

    describe "and it has not deserialized them yet" do
      before(:each) do
        @raw_walls = "0001"
        @walls = [ 'north' ]
        @tile.stub!(:[]).with(:walls).and_return(@raw_walls)
        @tile.instance_eval do
          @walls = nil
        end
      end

      it "should look at the raw tile[:walls]" do
        @tile.should_receive(:[]).with(:walls).once
        @tile.walls
      end

      it "should return the wall list" do
        @tile.walls.should eql(@walls)
      end
    end

    describe "and it has already deserialized them" do
      before(:each) do
        walls = []
        walls << Tile::WALL_DIRECTIONS[1]
        walls << Tile::WALL_DIRECTIONS[3]
        @tile.instance_eval do
          @walls = walls
        end
        @walls = walls
      end

      it "should not even look at the raw tile[:walls]" do
        @tile.should_not_receive(:[]).with(:walls)
        @tile.walls
      end

      it "should return the cached value" do
        @tile.walls.should equal(@walls)
      end
    end

    it "should return [ ] with raw walls '0000'" do
      @tile.stub!(:[]).with(:walls).and_return('0000')
      @tile.walls.should eql([])
    end

    it "should return [ 'east' ] with raw walls '1000'" do
      @tile.stub!(:[]).with(:walls).and_return('1000')
      @tile.walls.should eql([ 'east' ])
    end

    it "should return [ 'south' ] with raw walls '0100'" do
      @tile.stub!(:[]).with(:walls).and_return('0100')
      @tile.walls.should eql([ 'south' ])
    end

    it "should return [ 'west' ] with raw walls '0010'" do
      @tile.stub!(:[]).with(:walls).and_return('0010')
      @tile.walls.should eql([ 'west' ])
    end

    it "should return [ 'north' ] with raw walls '0001'" do
      @tile.stub!(:[]).with(:walls).and_return('0001')
      @tile.walls.should eql([ 'north' ])
    end

    it "should return [ 'east', 'west', 'north' ] with raw walls '1011'" do
      @tile.stub!(:[]).with(:walls).and_return('1011')
      @tile.walls.should eql([ 'east', 'west', 'north' ])
    end
  end
end
