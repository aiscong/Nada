class Event < ActiveRecord::Base
  #total decimal, name string, note text
  has_many :bills
  validates :name, presence: true
  validates :note, presence: true
end
