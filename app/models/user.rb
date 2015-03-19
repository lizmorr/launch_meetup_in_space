class User < ActiveRecord::Base
  has_many :memberships
  has_many :meetups
  has_many :meetups, through: :memberships

  validates :provider, presence: true
  validates :uid, presence: true,
    uniqueness: {scope: :provider}
  validates :username, presence: true
  validates :email,
    presence: true,
    format: {with: /\A\S+@\S+\.\S+\z/,
      message: "needs a valid e-mail address"}
  validates :avatar_url, presence: true

  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_by(provider: provider, uid: uid) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      username: auth.info.nickname,
      avatar_url: auth.info.image
    )
  end
end
