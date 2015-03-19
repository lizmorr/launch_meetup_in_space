class Meetup < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates  :name, presence: true, uniqueness: true
  validates :location, presence: true
  validates :description, presence: true
  validates :creator, presence: true
end
