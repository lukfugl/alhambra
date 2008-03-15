# currency, value
class Card < ActiveRecord::Base
  CURRENCIES = [
    'florin',
    'dirham',
    'denar',
    'dukat'
  ]
end
