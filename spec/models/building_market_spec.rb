require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildingMarket do
  before(:each) do
    @target = []
    @target.extend BuildingMarket
  end

  describe "when indexed" do
    before(:each) do
      @existing_slot = mock("existing slot", :currency => "existing", :null_object => true)
      @new_slot = mock("new slot", :null_object => true)
      @target << @existing_slot
      @target.stub!(:build).with(:currency => "new").and_return(@new_slot)
    end

    describe "with an existing currency" do
      it "should not build a new slot" do
        @target.should_not_receive(:build)
        @target["existing"]
      end

      it "should return the existing slot" do
        @target["existing"].should equal(@existing_slot)
      end
    end

    describe "with a new currency" do
      it "should build new slot" do
        @target.should_receive(:build).with(:currency => "new")
        @target["new"]
      end

      it "should return the new slot" do
        @target["new"].should equal(@new_slot)
      end
    end
  end

  describe "when setup" do
    before(:each) do
      @slots = {}
      Card::CURRENCIES.each do |currency|
        @slots[currency] = mock(currency)
        @target.stub!(:[]).with(currency).and_return(@slots[currency])
      end
    end

    it "should clear each slot" do
      Card::CURRENCIES.each do |currency|
        @slots[currency].should_receive(:tile=).with(nil)
        @slots[currency].should_receive(:save)
      end
      @target.setup
    end
  end

  describe "when replenished" do
    before(:each) do
      @slots = {}
      Card::CURRENCIES.each do |currency|
        @slots[currency] = mock("slot #{currency}")
        @target.stub!(:[]).with(currency).and_return(@slots[currency])
      end
      Event::BuildingMarketStocked.stub!(:create)
      @supply = mock("building supply", :null_object => true)
    end

    it "should check each slot for a tile" do
      Card::CURRENCIES.each do |currency|
        @slots[currency].should_receive(:tile)
      end
      @target.replenish(@supply)
    end

    describe "with no empty slots" do
      before(:each) do
        Card::CURRENCIES.each do |currency|
          @slots[currency].stub!(:tile).and_return(mock("tile #{currency}"))
        end
      end

      it "should not draw any tiles from the supply" do
        @supply.should_not_receive(:draw)
        @target.replenish(@supply)
      end

      it "should not create any events" do
        Event::BuildingMarketStocked.should_not_receive(:create)
        @target.replenish(@supply)
      end
    end

    describe "with an empty slot" do
      before(:each) do
        Card::CURRENCIES.each do |currency|
          @slots[currency].stub!(:tile).and_return(mock("tile #{currency}"))
        end
        @empty_slot = @slots[Card::CURRENCIES.first]
        @empty_slot.stub!(:tile).and_return(nil)
        @tile = mock("new tile")
        @supply.stub!(:draw).and_return(@tile)
      end

      it "should draw one tile from the supply" do
        @supply.should_receive(:draw).once
        @target.replenish(@supply)
      end

      it "should create a BuildingMarketStocked event with the empty slot and the drawn tile" do
        Event::BuildingMarketStocked.should_receive(:create).with(:slot => @empty_slot, :tile => @tile)
        @target.replenish(@supply)
      end
    end
  end

  describe "when a tile is taken" do
    before(:each) do
      @currency = mock("currency")
      @slot = mock("slot")
      @target.stub!(:[]).with(@currency).and_return(@slot)
    end

    it "should check for a tile in the slot" do
      @slot.should_receive(:tile)
      @target.take(@currency)
    end

    describe "but the slot is empty" do
      before(:each) do
        @slot.stub!(:tile).and_return(nil)
      end

      it "should not do anything to the slot" do
        # @slot is not a null_object, so any call would cause a failure
        @target.take(@currency)
      end

      it "should return nil" do
        @target.take(@currency).should be_nil
      end
    end

    describe "and the slot is not empty" do
      before(:each) do
        @tile = mock("tile")
        @slot.stub!(:tile).and_return(@tile)
        @slot.stub!(:tile=)
        @slot.stub!(:save)
      end

      it "should clear the slot" do
        @slot.should_receive(:tile=).with(nil)
        @slot.should_receive(:save)
        @target.take(@currency)
      end

      it "should return the tile" do
        @target.take(@currency).should equal(@tile)
      end
    end
  end
end
