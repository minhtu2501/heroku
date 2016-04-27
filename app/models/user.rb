class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", 
  								foreign_key: "follower_id", dependent: :destroy 
  has_many :passive_relationships, class_name: "Relationship",
  								foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments

  has_attached_file :avatar, style: {show: "100x100", default_url: 'missing_:avatar.png'}
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #      :recoverable, :rememberable, :trackable, :validatable
	#attr_accessor :password, :password_confirmation	
	
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, 
				format: {with: VALID_EMAIL_REGEX},
				uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: {minimum: 6}
#	validates :password_confirmation, presence: {if: :requires_password?}

#private
 # def requires_password?
 #   new_record? || !password.nil?
#  end
	class << self
		
		def digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
													  BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end

		def new_token
			SecureRandom.urlsafe_base64
		end

		# def search(search)
  # 		# Name is for the above case, the OP incorrectly had 'name'
  # 	 		if search
  #  				where('name LIKE ?', "%#{search}%")
  # 			end	
		# end
	end
	
	def activate 
		update_attribute(:activated, true)
		update_attribute(:activate_at, Time.zone.now)
	end	

	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digets(remember_token))
	end

	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	def send_password_reset_email
		UserMailer.send_password_reset(self).deliver_now
	end

	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end
	
	def feed
		following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
   		Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
	end

	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	#return true if the current user is following the other user
	def following?(other_user)
		following.include?(other_user)
	end


	private

	def downcase_email
		self.email = email.downcase
	end

	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

end

