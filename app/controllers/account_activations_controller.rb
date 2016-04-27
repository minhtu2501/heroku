class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: prams[:email])
		if user && !user.activated? && user.authenticated?(:activation, prams[:id])
			user.activated
			log_in user
			flash[:success] = "Account activated!"
			redirect_to user
		else
			flash[:danger] = "Invalid activation link!"
			redirect_to root_path				
		end
	end

end
