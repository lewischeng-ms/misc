require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
  end

  test "check users link before and after logged in" do
    get root_path
    assert_select "a[href=?]", users_path, count: 0
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", users_path, count: 1
  end
end