# frozen_string_literal: true
class TokensController < Doorkeeper::TokensController
    def create
        if params[:grant_type] == 'refresh_token'
            if request.cookies['tokens'] == ''
                return self.unauthorized_response
            end

            if request.headers['User-App'] == 'UserApp'
                tokens = request.headers['tokens']
            else
                tokens = request.cookies['tokens']
            end

            jwt = self.decode_jwt(tokens)
            refresh_token = JSON.parse(tokens)["refresh_token"] 

            if !self.can_refresh(jwt, refresh_token)
                self.revoke_tokens(jwt)
                self.delete_cookies
                return self.unauthorized_response
            end
            
            super

            self.revoke_token(OauthAccessToken.find_by(refresh_token: refresh_token))
            
            return
        end

        super
    end

    def sign_out
        self.delete_cookies
        self.revoke_tokens(self.decode_jwt(request.cookies['tokens']))
    end

    private

    def can_refresh(jwt, refresh_token)
        if request.cookies['tokens'] == ''
            return false
        end
        
        if OauthAccessToken.find_by(refresh_token: refresh_token)[:revoked_at] != nil
            return false
        end

        user_id = jwt["user"]["id"]

        tokens = OauthAccessToken
        .where("created_at > ?", Time.current.utc - 13.hours)
        .and(OauthAccessToken.where(resource_owner_id: user_id))
        .select(:refresh_token, :previous_refresh_token)

        if tokens == []
            return false
        end

        tokens_hash = {}

        tokens.each do |token|
            tokens_hash[token['refresh_token']] = token['previous_refresh_token']
        end

        current = tokens_hash[refresh_token]

        while current != nil
            if current == ''
                return true
            end

            current = tokens_hash[current]
        end

        return false
    end

    def decode_jwt(tokens)
         return JWT.decode(JSON.parse(tokens)['jwt'], nil, false)[0]
    end

    def unauthorized_response
        return  render(json: { error: 'Unauthorized.'}, status: 401 )
    end

    def delete_cookies 
        cookie_args = [
            "tokens=",
            'Path=/',
            'HttpOnly',
            "Expires= #{Time.current.utc.to_fs(:rfc822)}",
          ]
          
          cookie = cookie_args.join('; ')
          response.headers['Set-Cookie'] = cookie
    end

    def revoke_tokens(jwt)
        user_id = jwt['user']['id']
        tokens = OauthAccessToken.where(resource_owner_id: user_id).and(OauthAccessToken.where(revoked_at: nil))

        tokens.each do |t|
            self.revoke_token(t)
        end
    end

    def revoke_token(token)
        token.revoked_at = Time.current.utc
        token.save
    end
end
