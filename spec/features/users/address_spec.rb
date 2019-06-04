require 'rails_helper'

RSpec.describe "user profile - address " do
  before :each do
    @user = create(:user)
    @a1 = @user.addresses.create(nickname: 'home', street: 'Street 1', city: 'City 1', state: 'CO', zip: '1')
    @a2 = @user.addresses.create(nickname: 'work', street: 'Street 2', city: 'City 2', state: 'CO', zip: '2')
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

    it "user sees link delete an address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      within "#address-details-#{@a1.id}" do
        expect(page).to have_link('Delete Address')
      end

      within "#address-details-#{@a2.id}" do
        expect(page).to have_link('Delete Address')
      end
    end

    it "user can delete at address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      within "#address-details-#{@a2.id}" do
        click_link 'Delete Address'
      end

      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content(@a2.street)
    end
  end
end
