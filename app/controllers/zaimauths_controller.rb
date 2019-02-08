class ZaimauthsController < ApplicationController
	before_action :set_consumer, only: [:money, :create, :destroy]
	before_action :set_access_token, only: [:create, :money, :destroy]

	CONSUMER_KEY = ENV['CONSUMER_KEY']
	CONSUMER_SECRET = ENV['CONSUMER_SECRET']
	CALLBACK_URL = 'http://localhost:3000/callback'
	API_URL = 'https://api.zaim.net/v2/'

	def create
		set_category_list
		@account_data = {"mapping" => 1,
									 "category_id" => @categories.key(params["category_id"]),
						 "genre_id" => params["genre_id"],
						 "amount" => params["amount"],
						 "date" => Date.today.to_s
		}
		@access_token.post("#{API_URL}home/money/payment", @account_data)
		redirect_to money_path
	end

	def destroy
		set_consumer
		@access_token.delete("#{API_URL}home/money/payment/2945638392")
		redirect_to money_path
	end

	def money
		set_category_list
		money = @access_token.get("#{API_URL}home/money")
		@response = JSON.parse(money.body)
	end


	private

	#I converted it into a hash to use the list of categories in select_tag.
	def set_category_list
		categories_format_json = HTTPClient.get("#{API_URL}category").body
		categories_to_array = JSON.parse(categories_format_json)["categories"]
		categories_to_hash = Hash[*(categories_to_array.map{|category|category.values[0,2]}.flatten)]
		@categories = categories_to_hash
	end

	def set_consumer
		@consumer = OAuth::Consumer.new(CONSUMER_KEY,
																		CONSUMER_SECRET,
																		site: 'https://api.zaim.net',
																		request_token_path: '/v2/auth/request',
																		authorize_url: 'https://auth.zaim.net/users/auth',
																		access_token_path: '/v2/auth/access'
																	 )
	end

	def set_access_token
		@access_token = OAuth::AccessToken.new(@consumer, session[:access_token], session[:access_secret])
	end

end
