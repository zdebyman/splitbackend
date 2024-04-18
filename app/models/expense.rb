class Expense < ApplicationRecord
  belongs_to :payer, class_name: 'User'
  has_many :splits
  accepts_nested_attributes_for :splits

  validates :total_amount, presence: true, numericality: true
  validates :date, presence: true
  validates :payer_id, presence: true
  validates :split_type, presence: true
end
