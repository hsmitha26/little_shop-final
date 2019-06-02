require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant dashboard: ' do
  before :each do
    @merchant = create(:merchant)
    @i1, @i2 = create_list(:item, 2, user: @merchant, image: "https://picsum.photos/200/300")
    @i3 = create(:item, user: @merchant, image: "https://images.unsplash.com/photo-1545398865-0062dafeb74d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60")

    @other_merchant = create(:merchant)
    @i4 = create(:item, user: @other_merchant)

    @o1, @o2, @o5 = create_list(:order, 3)
    @o3 = create(:shipped_order)
    @o4 = create(:cancelled_order)

    #pending orders
    @oi1 = create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
    @oi2 = create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)

    @oi3 = create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)
    @oi6 = create(:order_item, order: @o2, item: @i4, quantity: 2, price: 2)

    @oi7 = create(:order_item, order: @o3, item: @i3, quantity: 9, price: 1)

    #shipped order
    @oi4 = create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)

    #cancelled order
    @oi5 = create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_path
  end

  describe 'under to-do list: ' do
    it "checks if they are using a default image for their items and alerts them." do
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
      expect(page).to have_content("You have #{Order.unfulfilled_order_count(@merchant.id)} unfulfilled order(s) worth #{number_to_currency(Order.unfulfilled_order_revenue(@merchant.id))}.")
    end

    it "should let merchant know if they have sufficient inventory to fulfill an order" do

      within "#order-#{@o1.id}" do
        expect(page).to have_content("Yes")
      end

      within "#order-#{@o2.id}" do
        expect(page).to have_content("Yes")
      end

      expect(page).to_not have_content(@o3)
      expect(page).to_not have_content(@o4)
    end

    it "should check all orders and let merchant know if they sufficient inventory for each item" do
      within "#items-to-do-#{@i1.id}" do
        expect(page).to have_content("Yes")
      end

      within "#items-to-do-#{@i2.id}" do
        expect(page).to have_content("Yes")
      end

      within "#items-to-do-#{@i3.id}" do
        expect(page).to have_content("No")
      end
    end
  end
end
