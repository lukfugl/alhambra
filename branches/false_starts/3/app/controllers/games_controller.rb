require 'atom/feed'

class GamesController < ApplicationController
  MediaContentType = 'alhambra/game'

  def index
    @feed = Atom::Feed.new(url_for())
    @feed.title = "Games"

    Game.find(:all).each do |game|
      entry = game.to_atom_entry

      entry.content = ''
      entry.content['src'] = game_entry_url(game)
      entry.content['type'] = MediaContentType

      edit_link = Atom::Link.new
      edit_link['href'] = game_media_url(game)
      edit_link['rel'] = 'edit'
      entry.links << edit_link

      @feed.entries << entry
    end

    render :text => @feed.to_s
  end
end
