class AddCategoryIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :category_id, :integer
  end
end
