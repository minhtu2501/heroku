class Picture < ActiveRecord::Base
	belongs_to :micropost #, foreign_key: 'micropost_id'
	validates :micropost, presence: true
	
	mount_uploader :picture, PictureUploader
	
	# has_attached_file :picture,
 #    :path => ":rails_root/public/images/:id/:filename",
 #    :url  => "/images/:id/:filename"

#  	do_not_validate_attachment_file_type :picture
end
