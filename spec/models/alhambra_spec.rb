require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Alhambra do
  describe "when lion_fountain is called" do
    before(:each) do
      @fountain = mock("fountain", :null_object => true)
      Alhambra.instance_eval{ @lion_fountain = nil }
    end

    it "should find the lion fountain tile by building type" do
      Tile.should_receive(:find_by_building_type).with('fountain').and_return(@fountain)
      Alhambra.lion_fountain
    end

    it "should return the fountain tile" do
      Tile.stub!(:find_by_building_type).and_return(@fountain)
      Alhambra.lion_fountain.should_equal @fountain
    end
  end

  describe "when lion_fountain is called a second time" do
    before(:each) do
      @fountain = mock("fountain", :null_object => true)
      Alhambra.instance_eval{ @lion_fountain = nil }
      Tile.stub!(:find_by_building_type).and_return(@fountain)
      Alhambra.lion_fountain
    end

    it "should not look for the tile again" do
      Tile.should_not_receive(:find_by_building_type)
      Alhambra.lion_fountain
    end

    it "should return the same fountain tile" do
      Alhambra.lion_fountain.should_equal @fountain
    end
  end

  describe "when setup is called" do
    before(:each) do
      @target = mock("target", :null_object => true)
      @target.extend Alhambra
    end

    it "target should be cleared" do
      @target.should_receive(:clear)

      @target.setup
    end

    it "target should have the fountain added at <0, 0>" do
      fountain = mock("fountain")
      Alhambra.should_receive(:lion_fountain).and_return(fountain)
      @target.should_receive(:create).with(:x => 0, :y => 0, :tile => fountain)

      @target.setup
    end
  end
end
