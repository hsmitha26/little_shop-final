require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe "Checking out" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @item_1 = create(:item, user: @merchant_1, inventory: 3)
    @item_2 = create(:item, user: @merchant_2)
    @item_3 = create(:item, user: @merchant_2)

    visit item_path(@item_1)
    click_on "Add to Cart"
    visit item_path(@item_2)
    click_on "Add to Cart"
    visit item_path(@item_3)
    click_on "Add to Cart"
    visit item_path(@item_3)
    click_on "Add to Cart"
  end

  it "should prompt user to add an address if they don't have one" do
    other_user = create(:user)
    login_as(other_user)
    visit cart_path

    click_link 'add an address'
    expect(current_path).to eq(new_profile_address_path)
  end

  context "as a logged in regular user" do
    before :each do
      user = create(:user)
      @a1 = create(:address, user: user)
      @a2 = create(:address, nickname: 'work', user: user)
      @a3 = create(:address, nickname: 'other', user: user)

      login_as(user)
      visit cart_path
    end

    it "should display all addresses for user and 'Use This Address' link" do
      within "#address-#{@a1.id}" do
        expect(page).to have_content(@a1.nickname)
        expect(page).to have_content(@a1.street)
        expect(page).to have_content(@a1.city)
        expect(page).to have_content(@a1.state)
        expect(page).to have_content(@a1.zip)
        expect(page).to have_link('Use This Address And Checkout')
      end
      within "#address-#{@a2.id}" do
        expect(page).to have_content(@a2.nickname)
        expect(page).to have_content(@a2.street)
        expect(page).to have_content(@a2.city)
        expect(page).to have_content(@a2.state)
        expect(page).to have_content(@a2.zip)
        expect(page).to have_link('Use This Address And Checkout')
      end
      within "#address-#{@a3.id}" do
        expect(page).to have_content(@a3.nickname)
        expect(page).to have_content(@a3.street)
        expect(page).to have_content(@a3.city)
        expect(page).to have_content(@a3.state)
        expect(page).to have_content(@a3.zip)
        expect(page).to have_link('Use This Address And Checkout')
      end
    end

    it "user chooses an address and it is associated with their new order" do
      within "#address-#{@a2.id}" do
        expect(page).to have_content(@a2.nickname)
        click_link('Use This Address And Checkout')
      end
      expect(current_path).to eq(profile_orders_path)
      @new_order = Order.last

      expect(page).to have_content("Your order has been created!")
      expect(page).to have_content("Cart: 0")

      within("#order-#{@new_order.id}") do
        expect(page).to have_link("Order ID #{@new_order.id}")
        expect(page).to have_content("Status: pending")
        expect(page).to have_content(@a2.nickname)
      end
    end

    it "should create a new order" do
      within "#address-#{@a2.id}" do
        expect(page).to have_content(@a2.nickname)
        click_link('Use This Address And Checkout')
      end
      @new_order = Order.last

      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Your order has been created!")
      expect(page).to have_content("Cart: 0")
      within("#order-#{@new_order.id}") do
        expect(page).to have_link("Order ID #{@new_order.id}")
        expect(page).to have_content("Status: pending")
      end
    end

    it "should create order items" do
      within "#address-#{@a2.id}" do
        expect(page).to have_content(@a2.nickname)
        click_link('Use This Address And Checkout')
      end
      @new_order = Order.last

      visit profile_order_path(@new_order)

      within("#oitem-#{@new_order.order_items.first.id}") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page.find("#item-#{@item_1.id}-image")['src']).to have_content(@item_1.image)
        expect(page).to have_content("Merchant: #{@merchant_1.name}")
        expect(page).to have_content("Price: #{number_to_currency(@item_1.price)}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Fulfilled: No")
      end

      within("#oitem-#{@new_order.order_items.second.id}") do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page.find("#item-#{@item_2.id}-image")['src']).to have_content(@item_2.image)
        expect(page).to have_content("Merchant: #{@merchant_2.name}")
        expect(page).to have_content("Price: #{number_to_currency(@item_2.price)}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Fulfilled: No")
      end

      within("#oitem-#{@new_order.order_items.third.id}") do
        expect(page).to have_content(@item_3.name)
        expect(page).to have_content(@item_3.description)
        expect(page.find("#item-#{@item_3.id}-image")['src']).to have_content(@item_3.image)
        expect(page).to have_content("Merchant: #{@merchant_2.name}")
        expect(page).to have_content("Price: #{number_to_currency(@item_3.price)}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Fulfilled: No")
      end
    end
  end

  context "as a visitor" do
    it "should tell the user to login or register" do
      visit cart_path

      expect(page).to have_content("You must register or log in to check out.")
      click_link "register"
      expect(current_path).to eq(registration_path)

      visit cart_path

      click_link "log in"
      expect(current_path).to eq(login_path)
    end
  end
end
