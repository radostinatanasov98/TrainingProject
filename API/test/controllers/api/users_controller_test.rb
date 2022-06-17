class UsersControllerTest <  ActionDispatch::IntegrationTest
    def token
        OauthAccessToken.find(1).token
    end

      
   # Defines tests for patients
    test "patients_should_return_401_without_authorization_header" do 
        get "/api/get_patients"

        assert_response 401
    end 

    test "patients_should_return_401_with_invalid_bearer_token" do 
        get "/api/get_patients",
        headers: { Authorization: "Bearer invalidToken" }

        assert_response 401
    end 

    test "patients_should_return_200_with_valid_token" do 
        get "/api/get_patients",
        headers: { Authorization: "Bearer #{self.token}" }

        assert_response 200
    end 

    # Defines tests for get_user
    test "get_user_should_return_401_without_authorization_header" do 
        get "/api/users/get_user"

        assert_response 401
    end 

    test "get_user_should_return_401_with_invalid_bearer_token" do 
        get "/api/users/get_user",
        headers: { Authorization: "Bearer invalidToken" }

        assert_response 401
    end 

    test "get_user_should_return_401_without_id_param" do 
        get "/api/users/get_user",
        headers: { Authorization: "Bearer #{self.token}" }

        assert_response 422
    end 

    test "get_user_should_return_401_with_invalid_id_param" do 
        get "/api/users/get_user",
        headers: { Authorization: "Bearer #{self.token}" },
        params: { id: -1 }

        assert_response 422
    end 

    test "get_user_should_return_200_with_valid_token_and_id_param" do 
        get "/api/users/get_user",
        headers: { Authorization: "Bearer #{self.token}" },
        params: { id: 1 }

        assert_response 200
    end 

    # Defines test for create
    test "create_should_return_403_with_invalid_client_id" do
        post "/api/users/create",
            params: {client_id: 'invalid'}

        assert_response 403
    end

    test "create_should_return_403_with_missing_client_id" do
        post "/api/users/create"

        assert_response 403
    end

    test "create_should_return_422_with_missing_user_params" do
        post "/api/users/create",
            params: {client_id: 'test_uid'}

        assert_response 422
    end

    test "create_should_return_422_without_email" do
        post "/api/users/create",
            params: { password: '123456', first_name: 'test', last_name: 'test', address: 'test', date_of_birth: '2022-06-13 12:53:52.005776', client_id: 'test_uid'}

        assert_response 422
    end

    test "create_should_return_422_without_password" do
        post "/api/users/create",
            params: { email: 'test_create@test.com', first_name: 'test', last_name: 'test', address: 'test', date_of_birth: '2022-06-13 12:53:52.005776', client_id: 'test_uid'}

        assert_response 422
    end

    test "create_should_return_422_without_first_name" do
        post "/api/users/create",
            params: { emial: 'test',password: '123456', last_name: 'test', address: 'test', date_of_birth: '2022-06-13 12:53:52.005776', client_id: 'test_uid'}

        assert_response 422
    end

    test "create_should_return_422_without_last_name" do
        post "/api/users/create",
            params: { email: 'test_create@test.com', password: '123456', first_name: 'test', address: 'test', date_of_birth: '2022-06-13 12:53:52.005776', client_id: 'test_uid'}

        assert_response 422
    end

    test "create_should_return_422_without_address" do
        post "/api/users/create",
            params: { email: 'test_create@test.com', password: '123456', first_name: 'test', last_name: 'test', date_of_birth: '2022-06-13 12:53:52.005776', client_id: 'test_uid'}

        assert_response 422
    end

    test "create_should_return_422_without_date_of_birth" do
        post "/api/users/create",
            params: { email: 'test_create@test.com', password: '123456', first_name: 'test', last_name: 'test', address: 'test', client_id: 'test_uid'}

        assert_response 422
    end

    test "create_should_return_200_with_valid_params" do
        post "/api/users/create",
            params: { email: 'test_create@test.com', password: '123456', first_name: 'test', last_name: 'test', address: 'test', date_of_birth: '2022-06-13 12:53:52.005776', client_id: 'test_uid'}

        assert_response 200
    end
end