require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event::GameCreated do
  before(:each) do
    @event = Event::GameCreated.new
    @game = mock("game")
    @seats = mock("seats")
  end

  describe "when effect_in_game is called" do
    before(:each) do
      @event.stub!(:build_game).and_return(@game)
      @game.stub!(:seats).and_return(@seats)
      @game.stub!(:save)
      @seats.stub!(:build)
    end

    it "should create a new game" do
      @event.should_receive(:build_game).with(:state => 'pre-game')
      @game.should_receive(:save)
      @event.effect_in_game
    end

    it "should add six seats to the game" do
      @seats.should_receive(:build).exactly(6).times
      @event.effect_in_game
    end
  end
end
