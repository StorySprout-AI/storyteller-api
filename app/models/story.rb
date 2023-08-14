class Story < ApplicationRecord
  has_many :user_stories
  has_many :users, through: :user_stories

  validates :description, presence: true
  validates :title, presence: true

  accepts_nested_attributes_for :user_stories, allow_destroy: true
end