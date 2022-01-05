# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get pages_home_url
    assert_response :success
  end

  test 'should get about' do
    get pages_about_url
    assert_response :success
  end

  test 'should get welcome' do
    get pages_welcome_url
    assert_response :success
  end

  test 'should get contact' do
    get pages_contact_url
    assert_response :success
  end
end
