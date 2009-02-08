Feature: Start a game
  In order to play a game of Alhambra
  A player should be able to start a new game

  Scenario: John successfully posts a game to the lobby feed
    Given there are some number of events
    And there are some number of games
    When John creates a GameCreated event
    And he sets the event name to 'My Game'
    And he posts the event to the lobby feed
    Then the response should have status 201 Created
    And there should be another event
    And there should be another game
    And the new game should have name 'My Game'
