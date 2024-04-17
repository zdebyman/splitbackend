class Split < ApplicationRecord
  belongs_to :expense
  belongs_to :payee, class_name: 'User'

  validates :amount, presence: true, numericality: true
  #validates :expense_id, presence: true
  validates :payee_id, presence: true
end
