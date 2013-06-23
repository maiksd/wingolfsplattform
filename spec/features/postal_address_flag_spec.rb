require 'spec_helper'

feature "Postal Address Flag" do
  include SessionSteps

  background do
    @user = create(:user_with_account)
    @home_address = @user.profile_fields.create( label: "Home Address", value: "Pariser Platz 1\n 10117 Berlin",
                                                 type: "ProfileFieldTypes::Address" )
      .becomes(ProfileFieldTypes::Address)
    @study_address = @user.profile_fields.create( label: "Study Address", value: "",
                                                  type: "ProfileFieldTypes::Address" )
      .becomes(ProfileFieldTypes::Address)
  end
  scenario "Selecting a postal address in the own user profile.", js: true do

    login @user
    visit user_path @user
    
    within ".box.section.contact_information" do

      page.should_not have_content "Wingolfspost"  # selector('.wingolfspost .label', visible: true)
      @user.postal_address_field.should == nil

      click_on I18n.t(:edit)
      first("input[type='radio']").click()
      wait_for_ajax
      
      visit user_path @user
      page.should have_content "Home Address Wingolfspost"
      page.should_not have_content "Study Address Wingolfspost"
      @user.postal_address_field.should == @home_address
      
      click_on I18n.t(:edit)
      find(".wingolfspost.profile_field_#{@study_address.id} input[type='radio']").click()
      wait_for_ajax

      visit user_path @user
      page.should_not have_content "Home Address Wingolfspost"
      page.should have_content "Study Address Wingolfspost"
      @user.postal_address_field.should == @study_address
      
    end

  end
end

def wait_for_ajax
  sleep 0.5
end