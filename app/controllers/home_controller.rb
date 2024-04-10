class HomeController < ApplicationController
	def index
		render json: :running
	end
end
