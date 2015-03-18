require 'spec_helper'

feature "User views all meetups" do
  # As a user
  # I want to view a list of all available meetups
  # So that I can get together with people with similar interests
  # Acceptance Criteria:
  #
  # Meetups should be listed alphabetically.
  # Each meetup listed should link me to the show page for that meetup.

  scenario "user sees all meetup information" do
    Meetup.create(name: "Hiking the craters of Mars",
                  location: "Mars",
                  description: "A group for those who want to explore Mars.",
                  creator_id: 3)
    visit '/'

    expect(page).to have_content "Hello World"
  end

  scenario "meetups are displayed alphabetically"
end
