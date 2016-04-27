class Micropost < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true
  belongs_to :user
  belongs_to :category

  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size
  validates :category, presence: true

  private

  def picture_size
  	if pictures.size > 5.megabytes
  		error.add(:picture, "Shoud be less than 5MB.")
  	end
  end
end
