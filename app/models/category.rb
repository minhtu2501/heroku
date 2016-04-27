class Category < ActiveRecord::Base
	has_many :microposts
end
