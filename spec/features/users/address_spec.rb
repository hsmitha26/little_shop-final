require 'rails_helper'

RSpec.describe "user profile - address " do
  before :each do
    @user = create(:user)
    @a1 = @user.addresses.create(nickname: 'home', street: 'Street 1', city: 'City 1', state: 'CO', zip: '1')
    @a2 = @user.addresses.create(nickname: 'work', street: 'Street 2', city: 'City 2', state: 'CO', zip: '2')
    @a3 = create(:address, user: @user)

    @o1 = create(:order, user: @user, address: @a1)
    @o2 = create(:shipped_order, user: @user, address: @a2)
  end

  describe 'visits profile_path ' do
    it "sees link to Add New Address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      expect(page).to have_link('Add New Address')
    end

    it "takes user to a form to add new address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      click_link 'Add New Address'
      expect(current_path).to eq(new_profile_address_path)
    end

    it "user can add another address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path
      click_link 'Add New Address'

      fill_in :address_nickname, with: 'mom'
      fill_in :address_street, with: 'Mom Street'
      fill_in :address_city, with: 'City'
      fill_in :address_state, with: 'State'
      fill_in :address_zip, with: '1'

      click_on 'Add New Address'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Mom')
    end

    it "user sees link delete an address and link to update address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      within "#address-details-#{@a1.id}" do
        expect(page).to have_link('Delete Address')
        expect(page).to have_link('Update Address')
      end

      within "#address-details-#{@a2.id}" do
        expect(page).to have_link('Delete Address')
        expect(page).to have_link('Update Address')
      end
    end

    it "user can delete at address, only if associated with an incomplete order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      within "#address-details-#{@a2.id}" do
        click_link 'Delete Address'
      end
      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Cannot delete an address associated with a completed order.")
      expect(page).to have_content(@a2.street)

      within "#address-details-#{@a1.id}" do
        click_link 'Delete Address'
      end
      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content(@a1.street)
    end

    it "user can update their address, only if associated with an incomplete order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      within "#address-details-#{@a1.id}" do
        click_link 'Update Address'
      end
      expect(current_path).to eq(edit_profile_address_path(@a1.id))

      fill_in :address_street, with: 'New Street'
      click_on 'Update Address'

      expect(current_path).to eq(profile_path)
      within "#address-details-#{@a1.id}" do
        expect(page).to have_content('Home')
        expect(page).to have_content(@a1.city)
        expect(page).to have_content('New Street')
      end

      within "#address-details-#{@a2.id}" do
        click_link 'Update Address'
      end
      expect(current_path).to eq(edit_profile_address_path(@a2.id))

      fill_in :address_street, with: 'New Street'
      click_on 'Update Address'
      expect(page).to have_content("Cannot update an address associated with a completed order.")
      expect(page).to have_content('Street 2')
    end
  end
end
