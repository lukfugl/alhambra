require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @event = Event.new
    @event_yaml = mock("yaml")
  end

  describe "when created" do
    before(:each) do
      @event_data = mock("data")
      @event.stub!(:event_data).and_return(@event_data)
      @event_data.stub!(:to_yaml).and_return(@event_yaml)
    end

    it "should trigger it's effect_in_game" do
      @event.should_receive(:effect_in_game)
      @event.save
    end

    it "should serialize it's event_data" do
      @event_data.should_receive(:to_yaml)
      @event.should_receive(:[]=).with(:event_data, @event_yaml)
      @event.save
    end
  end

  describe "when updated" do
    before(:each) do
      @event.save
      @event_data = mock("data")
      @event.stub!(:event_data).and_return(@event_data)
      @event_data.stub!(:to_yaml).and_return(@event_yaml)
    end

    it "should serialize it's event_data" do
      @event_data.should_receive(:to_yaml)
      @event.should_receive(:[]=).with(:event_data, @event_yaml)
      @event.save
    end
  end

  describe "when event_data is called" do
    describe "and the event_data hasn't been deserialized yet" do
      before(:each) do
        @event.instance_eval do
          @event_data = nil
        end
      end

      it "should look at event[:event_data]" do
        @event.should_receive(:[]).with(:event_data)
        @event.event_data
      end

      describe "and there's no event_data to deserialize" do
        before(:each) do
          @event.stub!(:[]).with(:event_data).and_return(nil)
        end

        it "should return {}" do
          @event.event_data.should eql({})
        end
      end

      describe "and there's event_data to deserialize" do
        before(:each) do
          @event_data = mock("data")
          @event.stub!(:[]).with(:event_data).and_return(@event_yaml)
          YAML.stub!(:load).with(@event_yaml).and_return(@event_data)
        end

        it "should deserialize the data with YAML" do
          YAML.should_receive(:load).with(@event_yaml)
          @event.event_data
        end

        it "should return the deserialized data" do
          @event.event_data.should equal(@event_data)
        end
      end
    end

    describe "and the event_data has already been deserialized" do
      before(:each) do
        data = mock("data")
        @event.instance_eval do
          @event_data = data
        end
        @event_data = data
      end

      it "shouldn't even look at event[:event_data]" do
        @event.should_not_receive(:[]).with(:event_data)
        @event.event_data
      end

      it "should return the previously deserialized data" do
        @event.event_data.should equal(@event_data)
      end
    end
  end
end
