class Group < ActiveRecord::Base
  has_many :reviewers
  has_many :users, through: :reviewers
  has_many :group_reviews
  has_many :movies, through: :group_reviews

  validates :group_name, { presence: true }
end
