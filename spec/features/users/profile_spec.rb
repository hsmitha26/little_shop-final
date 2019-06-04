require 'rails_helper'

RSpec.describe 'user profile', type: :feature do
  before :each do
    @user = create(:user)
    @a1 = @user.addresses.create(nickname: 'home', street: 'Street 1', city: 'City 1', state: 'CO', zip: '1')
    @a2 = @user.addresses.create(nickname: 'work', street: 'Street 2', city: 'City 2', state: 'CO', zip: '2')
  end

  describe 'registered user visits their profile' do
    it 'shows user information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path

      within '#profile-data' do
        expect(page).to have_content("Role: #{@user.role}")
        expect(page).to have_content("Email: #{@user.email}")
        within '#address-details' do
          expect(page).to have_content("Nickname: #{@a1.nickname.titleize}")
          expect(page).to have_content("#{@a1.street}")
          expect(page).to have_content("#{@a1.city}, #{@a1.state} #{@a1.zip}")

          expect(page).to have_content("Nickname: #{@a2.nickname.titleize}")
          expect(page).to have_content("#{@a2.street}")
          expect(page).to have_content("#{@a2.city}, #{@a2.state} #{@a2.zip}")
        end
        expect(page).to have_link('Edit Profile Data')
      end
    end
  end

  describe 'registered user edits their profile' do
    describe 'edit user form' do
      it 'pre-fills form with all but password information' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit profile_path

        click_link 'Edit'

        expect(current_path).to eq('/profile/edit')
        expect(find_field('Name').value).to eq(@user.name)
        expect(find_field('Email').value).to eq(@user.email)
        # expect(find_field('Street').value).to eq(@a1.street)
        # expect(find_field('City').value).to eq(@a1.city)
        # expect(find_field('State').value).to eq(@a1.state)
        # expect(find_field('Zip').value).to eq(@a1.zip)
        expect(find_field('Password').value).to eq(nil)
        expect(find_field('Password confirmation').value).to eq(nil)
      end
    end

    describe 'user information is updated' do
      before :each do
        @updated_name = 'Updated Name'
        @updated_email = 'updated_email@example.com'
        @updated_street = 'newest address'
        @updated_city = 'new new york'
        @updated_state = 'S. California'
        @updated_zip = '33333'
        @updated_password = 'newandextrasecure'
        @updated_nickname = 'other'
      end

      describe 'succeeds with allowable updates' do
        scenario 'all attributes are updated' do
          login_as(@user)
          old_digest = @user.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email
          fill_in :user_password, with: @updated_password
          fill_in :user_password_confirmation, with: @updated_password

          fill_in :user_addresses_attributes_1_nickname, with: @updated_nickname
          fill_in :user_addresses_attributes_1_street, with: @updated_street
          fill_in :user_addresses_attributes_1_city, with: @updated_city
          fill_in :user_addresses_attributes_1_state, with: @updated_state
          fill_in :user_addresses_attributes_1_zip, with: @updated_zip

          click_button 'Submit'

          updated_user = User.find(@user.id)

          expect(current_path).to eq(profile_path)

          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")
            within '#address-details' do
              expect(page).to have_content("#{@updated_address}")
              expect(page).to have_content("#{@updated_city}, #{@updated_state} #{@updated_zip}")
            end
          end
          expect(updated_user.password_digest).to_not eq(old_digest)
        end
        scenario 'works if no password is given' do
          login_as(@user)
          old_digest = @user.password_digest

          visit edit_profile_path

          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email

          fill_in :user_addresses_attributes_1_nickname, with: @updated_nickname
          fill_in :user_addresses_attributes_1_street, with: @updated_street
          fill_in :user_addresses_attributes_1_city, with: @updated_city
          fill_in :user_addresses_attributes_1_state, with: @updated_state
          fill_in :user_addresses_attributes_1_zip, with: @updated_zip

          click_button 'Submit'

          updated_user = User.find(@user.id)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")
            within '#address-details' do
              expect(page).to have_content("#{@updated_address}")
              expect(page).to have_content("#{@updated_city}, #{@updated_state} #{@updated_zip}")
            end
          end
          expect(updated_user.password_digest).to eq(old_digest)
        end
      end
    end

    it 'fails with non-unique email address change' do
      create(:user, email: 'megan@example.com')
      login_as(@user)

      visit edit_profile_path

      fill_in :user_email, with: 'megan@example.com'

      click_button 'Submit'

      expect(page).to have_content("Email has already been taken")
    end
  end
end
