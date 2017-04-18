require 'test_helper'

class GpasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gpa = gpas(:one)
  end

  test "should get index" do
    get gpas_url
    assert_response :success
  end

  test "should get new" do
    get new_gpa_url
    assert_response :success
  end

  test "should create gpa" do
    assert_difference('Gpa.count') do
      post gpas_url, params: { gpa: {  } }
    end

    assert_redirected_to gpa_url(Gpa.last)
  end

  test "should show gpa" do
    get gpa_url(@gpa)
    assert_response :success
  end

  test "should get edit" do
    get edit_gpa_url(@gpa)
    assert_response :success
  end

  test "should update gpa" do
    patch gpa_url(@gpa), params: { gpa: {  } }
    assert_redirected_to gpa_url(@gpa)
  end

  test "should destroy gpa" do
    assert_difference('Gpa.count', -1) do
      delete gpa_url(@gpa)
    end

    assert_redirected_to gpas_url
  end
end
