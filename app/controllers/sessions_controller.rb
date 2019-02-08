class SessionsController < ApplicationController
	before_action :set_consumer, only: [:login]

	CONSUMER_KEY = ENV['CONSUMER_KEY']
	CONSUMER_SECRET = ENV['CONSUMER_SECRET']
	CALLBACK_URL = 'http://localhost:3000/callback'
	API_URL = 'https://api.zaim.net/v2/'

  def top
  end

  def login
		@request_token = @consumer.get_request_token(oauth_callback: CALLBACK_URL)
		session[:request_token] = @request_token.token
		session[:request_secret] = @request_token.secret
		redirect_to @request_token.authorize_url(oauth_callback: CALLBACK_URL)
  end

  def logout
		session[:request_token] = nil
		session[:access_token] = nil
		redirect_to root_path
  end

	def callback
		if session[:request_token] && params[:oauth_verifier]
			set_consumer
			@oauth_verifier = params[:oauth_verifier]
			@request_token = OAuth::RequestToken.new(@consumer, session[:request_token], session[:request_secret])
			access_token = @request_token.get_access_token(oauth_verifier: @oauth_verifier)
			session[:access_token] = access_token.token
			session[:access_secret] = access_token.secret
			redirect_to money_path
		else
			logout
		end

	end

	private

	def set_consumer
		@consumer = OAuth::Consumer.new(CONSUMER_KEY,
																		CONSUMER_SECRET,
																		site: 'https://api.zaim.net',
																		request_token_path: '/v2/auth/request',
																		authorize_url: 'https://auth.zaim.net/users/auth',
																		access_token_path: '/v2/auth/access'
																	 )
	end

end
