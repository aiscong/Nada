class Bill < ActiveRecord::Base
  belongs_to :creditor, class_name: "User"
  belongs_to :debtor, class_name: "User"
  validates :creditor_id, presence: true
  validates :debtor_id, presence: true
end
