Rails.application.routes.draw do
	root to: 'homes#top'
	get 'info' => 'zaimauths#info'
	get 'money' => 'zaimauths#money'
	post 'create' => 'zaimauths#create'
  delete 'destroy' => 'zaimauths#destroy'
	get 'top' => 'homes#top'
	get 'login' => 'sessions#login'
	delete 'logout' => 'sessions#logout'
	get 'callback' => 'sessions#callback'
end
