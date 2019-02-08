class HomesController < ApplicationController

	def top
		redirect_to money_path if session[:request_token] && session[:access_token]
	end

end
