require File.dirname(__FILE__) + '/../spec_integration_helper'
require 'atom/feed'

describe "GET /games" do
  before(:each) do
    session = open_session
    session.get "/games"
    @response = session.response
  end

  it "should have a 200 response code" do
    @response.response_code.should == 200
  end

  it "should return a parseable Atom feed" do
    proc{ Atom::Feed.parse(@response.body) }.
      should_not raise_error
  end

  it "feed should have a title of 'Games'" do
    feed = Atom::Feed.parse(@response.body)
    feed.title.to_s.should == "Games"
  end
end

describe "GET /games, when there are no games" do
  before(:each) do
    session = open_session
    session.get "/games"
    @response = session.response
    @feed = Atom::Feed.parse(@response.body)
  end

  it "feed should have no entries" do
    @feed.entries.should be_empty
  end

  it "feed should have no rel='next' link" do
    @feed.next.should be_nil
  end

  it "feed should have no rel='prev' link" do
    @feed.prev.should be_nil
  end
end

describe "GET /games, when there are games" do
  before(:each) do
    3.times{ |i| Game.create(:name => i + 1) }

    session = open_session
    session.get "/games"
    @response = session.response
    @feed = Atom::Feed.parse(@response.body)
  end

  after(:each) do
    Game.destroy_all
  end

  it "feed should have all games" do
    @feed.entries.size.should == Game.count
  end

  it "feed should have no rel='next' link" do
    @feed.next.should be_nil
  end

  it "feed should have no rel='prev' link" do
    @feed.prev.should be_nil
  end
end
