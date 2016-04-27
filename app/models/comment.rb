class Comment < ActiveRecord::Base
	belongs_to :micropost
	belongs_to :user
	has_many :childrens, class_name: "Comment", foreign_key: "parent_id"
	belongs_to :parent, class_name: "Comment"

	validates :content, presence: true
  	validates :user_id, presence: true
  	validates :micropost_id, presence: true 
end
