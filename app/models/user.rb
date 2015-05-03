class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, presence: true
  has_many :unpaid_bills, class_name: "Bill",
                          foreign_key: "debtor_id",
                          dependent:  :destroy
  #has_many :receivers, through: :unpaid_bills, source: :creditor
  has_many :unrec_bills, class_name: "Bill",
                         foreign_key: "creditor_id",
                         dependent:  :destroy
  has_many :friendships
  has_many :friends, :through => :friendships
  
    
  def sign_in(password)
    if self.authenticate(password)
      return true
    else 
      return false
    end
  end
  #has_many :payers, through: :unrec_bills, class_
end
