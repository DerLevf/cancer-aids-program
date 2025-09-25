require "test_helper"

class DebtProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get debt_projects_index_url
    assert_response :success
  end
end
