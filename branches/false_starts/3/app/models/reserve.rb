module Models
  class Reserve < ActiveRecord::Base
    belongs_to :seat
  end
end
