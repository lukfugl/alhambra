require File.dirname(__FILE__) + '/../test_helper'

class PlayerControllerTest < ActionController::TestCase
  def test_put_to_new_username_creates_a_user
    prior_count = Player.count
    put "put", :username => "newname",
      :player => { :name => "name" }
    assert_response :ok
    assert_equal prior_count + 1, Player.count
  end

  def test_put_to_existing_username_updates_that_user
    player = Player.create(:username => "newname", :name => "foo")
    prior_count = Player.count
    put "put", :username => player.username,
      :player => { :name => "bar" }
    assert_response :ok
    assert_equal prior_count, Player.count
    assert_equal "bar", player.reload.name
  end

  def test_delete_to_existing_username_destroys_that_user
    player = Player.create(:username => "newname")
    delete "delete", :username => player.username
    assert_response :ok
    assert_raises(ActiveRecord::RecordNotFound) { player.reload }
  end

  def test_delete_to_new_username_raises_a_404
    delete "delete", :username => "newname"
    assert_response :not_found
  end
end
