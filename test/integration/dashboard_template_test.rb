require "test_helper"

class DashboardTemplateTest < ActionDispatch::IntegrationTest
  test "root page renders the premium dashboard shell" do
    get root_url

    assert_response :success
    assert_select "h1", /Concreto Master/
    assert_select "[data-controller='theme']"
  end
end
