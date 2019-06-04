class Profile::AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    user = current_user
    address = Address.create(address_params)
    user.addresses << address
    redirect_to profile_path
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to profile_path
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :street, :city, :state, :zip)
  end
end
