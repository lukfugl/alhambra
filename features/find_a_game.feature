Feature: find a new game
  In order to play in a game
  A player should be able to find a game to join
  
  Scenario: Alex checks the lobby for games
    Given a game (Bob's game) exists
    When Alex goes to the lobby
    Then he should see a GameList representation
    And that representation should include the URI for Bob's game
  
  Scenario: Alex examines a game
    Given a game (Bob's game) exists
    When Alex goes to the URI for Bob's game
    Then he should see a Game representation
    And that representation's uri should be the URI for Bob's game
