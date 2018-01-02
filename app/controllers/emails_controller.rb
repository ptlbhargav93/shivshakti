class EmailsController < ApplicationController

  include ApplicationHelper
  
  before_action :authenticate_user!

end