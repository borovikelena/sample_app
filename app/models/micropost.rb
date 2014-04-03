class Micropost < ActiveRecord::Base
  include PublicActivity::Model

  tracked owner: Proc.new{ |controller, model| controller.current_user }

  @@reply_to_regexp = /(\d+)-([\w+\-.]*)/
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  belongs_to :in_reply_to, class_name: "User"
  belongs_to :user

  before_save :extract_in_reply_to

  default_scope -> { order('created_at DESC') }
  scope :from_users_followed_by_including_replies, lambda { |user| followed_by_including_replies(user) }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def self.followed_by_including_replies(user)
    followed_ids = %(SELECT followed_id FROM relationships
                   WHERE follower_id = :user_id)
    where("user_id IN (#{followed_ids}) OR user_id = :user_id OR in_reply_to_id = :user_id OR in_reply_to_id IN (#{followed_ids})",
        { :user_id => user })
  end

  def self.search(search)
    where("content LIKE ?", "%#{search}%")
  end

  def extract_in_reply_to
    if match = @@reply_to_regexp.match(content)
      user = User.find(match[1])
      self.in_reply_to = user if user
    end
  end


end
