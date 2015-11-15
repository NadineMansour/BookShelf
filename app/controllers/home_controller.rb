class HomeController < ApplicationController

	before_action :set_auth
  

  private

  def set_auth
  	@auth = session[:omniauth] if session[:omniauth]
  end
  
end
