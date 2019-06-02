require 'rails_helper'

RSpec.describe 'Merchant dashboard: ' do
  before :each do
    @merchant = create(:merchant)
    @admin = create(:admin)
    @i1, @i2 = create_list(:item, 2, user: @merchant, image: "https://picsum.photos/200/300")
    @i3 = create(:item, user: @merchant, image: "https://images.unsplash.com/photo-1545398865-0062dafeb74d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")
    @o1, @o2 = create_list(:order, 2)
    @o3 = create(:shipped_order)
    @o4 = create(:cancelled_order)

    #pending orders
    @oi1 = create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
    @oi2 = create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)
    @oi3 = create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)

    #shipped order
    @oi4 = create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)

    #cancelled order
    @oi5 = create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)
  end

  describe 'under to-do list: ' do
    it "checks if they are using a default image for their items and alerts them." do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_path

      expect(page).to have_content("Pending Tasks")
      expect(page).to_not have_link(@i3.name)

      within ("#items-to-do-#{@i1.id}") do
        expect(page).to have_link(@i1.name)
      end

      within ("#items-to-do-#{@i2.id}") do
        expect(page).to have_link(@i2.name)
      end

      click_on @i1.name
      expect(current_path).to eq(edit_dashboard_item_path(@i1))
    end

    it "should display a list of unfulfilled orders and potential revenue for merchant's items." do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_path
      within "#orders-to-do-#{@o1}" do
        
      end
    end
  end
end
