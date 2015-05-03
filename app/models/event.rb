class Event < ActiveRecord::Base
  #total decimal, name string, note text
  has_many  :bills, dependent: :destroy
  validates :name, presence: true
  validates :note, presence: true
end
