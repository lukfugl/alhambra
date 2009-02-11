Feature: join a game
  In order to play a game
  A player should be able to join a game

  Scenario: Alice posts a SeatOccupied event to a game
    Given a game (Bob's game) exists
    And a seat (the seat) exists
    And Bob's game's seats include the seat
    When Alice creates a SeatOccupied event
    And she sets the event seat to the URI for the seat
    And she posts the event to the event feed for Bob's game
    Then the response should have status 201 Created
    And there should be another event
