require 'rails_helper'

RSpec.describe 'merchant dashboard' do
  before :each do
    @merchant = create(:merchant)
    @admin = create(:admin)
    @i1, @i2 = create_list(:item, 2, user: @merchant)
    @o1, @o2 = create_list(:order, 2)
    @o3 = create(:shipped_order)
    @o4 = create(:cancelled_order)
    create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
    create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)
    create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)
    create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)
    create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)
  end

  describe 'merchant visits their dashboard, where they see a to-do list' do
    it "checks if they are using a default image" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_path

      expect(page).to have_content("Pending Tasks")
    end
  end
end
