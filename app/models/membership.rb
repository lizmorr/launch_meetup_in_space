class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates :user, presence: true
  validates :meetup, presence: true,
    uniqueness: {scope: :user,
      message: "has already been joined by user."}
end
