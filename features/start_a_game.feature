Feature: Start a game
  In order to play a game of Alhambra
  A player should be able to start a new game by posting a GameCreated event to
  the lobby feed

  Scenario: John posts a GameCreated event to the lobby feed
    Given there are some number of events
    And there are some number of games
    When John creates a GameCreated event
    And he sets the event name to 'My Game'
    And he posts the event to the event feed for the lobby
    Then the response should have status 201 Created
    And there should be another event
    And there should be another game (John's game)
    And John's game should have name 'My Game'

  Scenario: Jane forgets to include the name in a GameCreated event
    Given there are some number of events
    And there are some number of games
    When Jane creates a GameCreated event
    And she doesn't set the event name
    And she posts the event to the event feed for the lobby
    Then the response should have status 400 Bad Request
    And there should not be another event
    And there should not be another game
