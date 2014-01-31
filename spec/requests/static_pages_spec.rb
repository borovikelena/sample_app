require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home page" do
    before { visit root_path }

    it "should have the content 'Sample App'" do
      expect(page).to have_content('Sample App')
    end

    it "should have the title base title" do
      expect(page).to have_title("#{base_title}")
    end

    it "should not have custom page title" do
      expect(page).not_to have_title(" | Home")
    end

  end

  describe "Help page" do
    before { visit help_path }

    it "should have the content 'Help'" do
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      expect(page).to have_title("#{base_title} | Help")
    end

  end

  describe "About page" do
    before { visit about_path }

    it "should have the content 'About us'" do
      expect(page).to have_content('About us')
    end

    it "should have the title 'About us'" do
      expect(page).to have_title("#{base_title} | About us")
    end
  end
end
