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
    address.orders.each do |order|
      if (order.status == 'shipped') || (order.status == 'packaged')
        flash[:danger] = "Cannot delete an address associated with a completed order."
        redirect_to profile_path
      elsif (order.status == 'cancelled') || (order.status == 'pending')
        address.orders.clear
        address.destroy
        redirect_to profile_path
      end
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    address = Address.find(params[:id])
    address.orders.each do |order|
      if (order.status == 'shipped') || (order.status == 'packaged')
        flash[:danger] = "Cannot update an address associated with a completed order."
        redirect_to profile_path
      elsif (order.status == 'cancelled') || (order.status == 'pending')
        address.update(address_params)
        redirect_to profile_path
      end
    end
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :street, :city, :state, :zip)
  end
end
