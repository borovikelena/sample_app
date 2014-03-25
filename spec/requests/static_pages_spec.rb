require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    it {should have_content('About us')}
    it {should have_title(full_title("About us"))}

  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user, email:'elena.borovik@gameloft.com') }
    before do
      5.times { |n| FactoryGirl.create(:micropost, user:user2, content: "Some content#{n}") }
      15.times { |n| FactoryGirl.create(:micropost, user:user, content: "Some content#{n}") }

      sign_in user
      visit root_path
    end

    it { should have_selector('div.pagination') }
    it { should have_content(user.feed.count) }


    it "should list each micropost" do
      user.feed.paginate(page: 1, :per_page => 10).each do |item|
        expect(page).to have_selector("li##{item.id}", text: item.content)
        expect(page).not_to have_link('delete', href: micropost_path(item)) unless item.user == user
      end
    end

    describe "follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit root_path
      end

      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
    end
  end
  
end
 