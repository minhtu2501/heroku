class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		if user.activated?
  			log_in user
  			params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  			redirect_back_or root_path
  		else
  			message = "Account not activated. "
  			message += "Check your email for the activation link."
  			flash[:warning] = message
  			redirect_to root_path
  		end
  	else
  		flash[:danger] = 'Email or Password Wrong!'	
  		render action: 'new'
  	end
  end


  def destroy
  	log_out if logged_in?
  	redirect_to root_path
  end

end
