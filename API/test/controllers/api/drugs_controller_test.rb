class DrugsControllerTest < ActionDispatch::IntegrationTest
    test "get_drugs_should_return_unauthorized_if_authorization_header_is_missing" do
      get "/api/get_drugs"
  
      assert_response 401
    end

    test "get_drugs_should_return_unauthorized_if_authorization_header_is_invalid" do
        get "/api/get_drugs",
            headers: { Authorization: "Bearer invalidtoken" }
    
        assert_response 401
      end

      test "get_drugs_should_return_OK_if_auhtorization_header_is_valid" do
        get "/api/get_drugs",
            headers: { Authorization: "Bearer #{OauthAccessToken.find(1).token}" }
    
        assert_response 200
      end
  end