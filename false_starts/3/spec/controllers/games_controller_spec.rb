require File.dirname(__FILE__) + '/../spec_helper'

describe GamesController, "#index [GET]" do
  before(:each) do
    get 'index'
    @feed = assigns(:feed)
  end

  it "should have a 200 response code" do
    response.response_code.should == 200
  end

  it "should assign @feed as an Atom::Feed" do
    @feed.should be_kind_of(Atom::Feed)
  end

  it "feed should have a title of 'Games'" do
    @feed.title.to_s.should == "Games"
  end
end

describe GamesController, "#index [GET], feed returned when there are no games" do
  before(:each) do
    Game.stub!(:find).and_return([])
    get 'index'
    @feed = assigns(:feed)
  end

  it "should have no entries" do
    @feed.entries.should be_empty
  end

  it "should have no rel='next' link" do
    @feed.next.should be_nil
  end

  it "should have no rel='prev' link" do
    @feed.prev.should be_nil
  end
end

describe GamesController, "#index [GET], feed returned when there are some games" do
  before(:each) do
    @games = (1..3).map do |i|
      entry = Atom::Entry.new
      entry.id = i.to_s
      game = mock("game #{i}")
      game.stub!(:to_atom_entry).and_return(entry)
      game
    end
    Game.stub!(:find).and_return(@games)

    get 'index'
    @feed = assigns(:feed)
  end

  it "should have all the entries" do
    @feed.entries.size.should == @games.size
  end

  it "should have no rel='next' link" do
    @feed.next.should be_nil
  end

  it "should have no rel='prev' link" do
    @feed.prev.should be_nil
  end
end

describe GamesController, "#index [GET], one of the returned entries" do
  before(:each) do
    entry = Atom::Entry.new
    entry.id = "game"
    @game = mock("game")
    @game.stub!(:to_atom_entry).and_return(entry)
    @game.stub!(:to_param).and_return(1)
    Game.stub!(:find).and_return([ @game ])

    get 'index'
    @feed = assigns(:feed)
    @entry = @feed.entries.first
  end

  it "should have exactly one content element" do
    @entry.content.should be_kind_of(Atom::Content)
  end

  it "should have the game_entry_url as the content src" do
    @entry.content['src'].should == game_entry_url(@game)
  end

  it "should have the correct content type" do
    @entry.content['type'].should == GamesController::MediaContentType
  end

  it "should have the game_media_url as the edit url" do
    @entry.edit_url.should == game_media_url(@game)
  end
end
