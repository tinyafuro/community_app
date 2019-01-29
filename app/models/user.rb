class User < ApplicationRecord
  
  # ActiveRecordのコールバックメソッド（before_save > DBに保存する前に呼ばれる）
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }   #破壊的メソッド

  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGE_ = /\A[\w+\-.]+@[a-z\d\-.]+               \.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\- ]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

end
