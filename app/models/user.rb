class User < ActiveRecord::Base
	attr_accessor :remember_token
	has_many :entries, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship",
									foreign_key: "follower_id",
									dependent: :destroy

	has_many :passive_relationships, class_name: "Relationship",
								foreign_key: "followed_id",
								dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	has_many :comments, dependent: :destroy

	before_save :downcase_email
	validates :name, presence: true, length: {maximum: 100}
	VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255},
					format: { with: VALID_EMAIL },
					uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, allow_blank: true

	def create_digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
	end

	def new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = new_token
		update_attribute(:remember_digest, create_digest(remember_token))
	end

	def authenticated?(remember_token)
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def feed
		Entry.where("user_id IN(?) or user_id = ?",following_ids, id)
	end

	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	def following?(other_user)
		following.include?(other_user)
	end

	private
		def downcase_email
			self.email = email.downcase
		end
end
