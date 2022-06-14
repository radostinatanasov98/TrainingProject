class ExaminationsControllerTest < ActionDispatch::IntegrationTest
  # Defines variables

  def token
    OauthAccessToken.find(1).token
  end

  # Tests for Action: create


  test "create_should_return_OK_with_valid_params" do
    post "/api/examinations/create",
      headers: { Authorization: "Bearer #{self.token}" },
      params: { user_id: 1, weight_kg: 80, height_cm: 180, anamnesis: 'test', perscription: { description: 'test', drugs: [ { drug_id: 1, usage_description: 'test' } ] } }

    puts 80.class == Integer
    puts 'test'.class == String
    puts [{id: 1, ug: 'test'}] != nil
    assert_response 200
  end

  # Tests for Action: get_by_id 
  test "get_by_id_should_return_unathorized_without_authorization_header" do
    get "/api/examinations/get_by_id"

    assert_response 401
  end

  test "get_by_id_should_return_unathorized_without_valid_authorization_header" do
    get "/api/examinations/get_by_id",
      headers: { Authorization: "Bearer invalid_token" }

    assert_response 401
  end

  test "should_return_unprocessable_entity_if_id_param_is_not_present" do
    get "/api/examinations/get_by_id", 
      headers: { Authorization: "Bearer #{self.token}" }

    assert_response 422
  end

  test "should_return_unprocessable_entity_if_invalid_id_param_is_sent" do
    get "/api/examinations/get_by_id", 
    headers: { Authorization: "Bearer #{self.token}" },
    params: { id: -1 }

    assert_response 422
  end

  test "should_return_OK_if_valid_id_param_is_present" do
    get "/api/examinations/get_by_id", 
    headers: { Authorization: "Bearer #{self.token}" },
    params: { id: 1 }

    assert_response 200
  end
end