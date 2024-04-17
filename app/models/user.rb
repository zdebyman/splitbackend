class User < ApplicationRecord
  has_secure_password

  has_many :expenses, class_name: 'Expense', foreign_key: 'payer_id'
  has_many :splits, foreign_key: 'payee_id'

  validates :username, presence: true, uniqueness: true
end
