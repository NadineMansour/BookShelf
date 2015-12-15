class Api::BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_action :verify_authenticity_token
  respond_to :json

  private 

  def current_user 
  	@current_user ||= User.find_by_token(request.headers[:authorization])
  end

  helper_method :current_user

end
