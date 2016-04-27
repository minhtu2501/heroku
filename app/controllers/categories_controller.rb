class CategoriesController < ApplicationController
	
	def index
		@categories = Category.all
	end

	def new
		@category = Category.new
	end

	def show
		@category = Category.find(params[:id])
	end
	
	def create
		@category = Category.new(category_params)
		if @category.save
			redirect_to root_path
		else
			render action: 'new'
		end
	end

	def destroy
		@category = Category.find(params[:id])
		@category.destroy
	end

	private

	def category_params
		params.require(:category).permit(:name)
	end
end
