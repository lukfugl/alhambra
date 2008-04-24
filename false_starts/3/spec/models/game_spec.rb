require File.dirname(__FILE__) + '/../spec_helper'

describe "A game's entry" do
  before(:each) do
    @game = Game.create(
      :name => "name",
      :created_at => Time.now - 2.days,
      :updated_at => Time.now,
      :summary => "summary"
    )
    @entry = @game.to_atom_entry
  end

  it "should be an Atom::Entry" do
    @entry.should be_kind_of(Atom::Entry)
  end

  it "should have the game's uuid as id" do
    @entry.id.should == @game.uuid.to_s
  end

  it "should have the game's name as title" do
    @entry.title.to_s.should == @game.name
  end

  it "should have the game's created_at as published" do
    @entry.published.should == @game.created_at
  end

  it "should have the game's updated_at as updated" do
    @entry.updated.should == @game.updated_at
  end

  it "should have the game's summary as summary" do
    @entry.summary.to_s.should == @game.summary
  end
end
