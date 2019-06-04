class Profile::AddressesController < ApplicationController
  def new
    @user = current_user
    @address = @user.addresses.new
  end
end
