module CookieTokenResponse
    def body
      super.except('access_token', 'token_type')
    end

    def headers
        cookie_args = [
          "access_token=#{token.token}",
          'Path=/',
          'HttpOnly',
        ]
         
        cookie = cookie_args.join('; ')

        super.merge({'Set-Cookie' => cookie})
    end

    private

    def can_refresh(id)
        tokens = OauthAccessToken
        .where("created_at > ?", Time.current.utc - 13.hours)
        .and(OauthAccessToken.where(resource_owner_id: id))
        .select(:refresh_token, :previous_refresh_token)
        
        if tokens == []
           return render json: 'false'
        end

        current_token = tokens.last['refresh_token']

        tokens_hash = {}

        tokens.each do |token|
            tokens_hash[token['refresh_token']] = token['previous_refresh_token']
        end

        current = tokens_hash[current_token]

        while current != ''
            if tokens_hash[current] == nil
                return true
            end
            
            current = tokens_hash[current]
        end

        return false
    end
  end