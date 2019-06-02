class Dashboard::DashboardController < Dashboard::BaseController
  def index
    @merchant = current_user
    @pending_orders = Order.pending_orders_for_merchant(current_user.id)
    @unfulfilled_order_count = Order.unfulfilled_order_count(current_user.id)
  end
end
