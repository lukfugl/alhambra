Feature: Start a game
  In order to play a game of Alhambra
  A player should be able to start a new game

  Scenario: John successfully posts a game to the lobby feed
    Given there are some number of games
    When John posts the GameCreated event in my_game.yml to the lobby feed
    Then there should be 1 more game
