class User < ActiveRecord::Base

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  before_create :create_activation_token
  #default_scope { where state: 'active' }


  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, maximum: 50 }, :if => :validate_password?
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_secure_password

  state_machine initial: :inactive do
    state :inactive, value: 0
    state :active, value: 1

    event :activate do
      transition :inactive => :active
    end

    event :inactivate do
      transition :active => :inactive
    end
  end

  
  #before_save { email.downcase! }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # Это предварительное решение. См. полную реализацию в "Following users".
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def not_notice_user
    not_notice
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
  end

  private
    def validate_password?
      password.present? || password_confirmation.present?
    end
    def create_activation_token
      generate_token(:activation_token)
      self.activation_token_sent_at = Time.zone.now
    end

    def create_remember_token
    	self.remember_token = User.encrypt(User.new_remember_token)
    end

    def generate_token(column)
      begin
        self[column] = User.new_remember_token
      end while User.exists?(column => self[column])
    end
end
