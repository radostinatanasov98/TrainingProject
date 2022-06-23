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

            if !self.can_refresh(tokens)
                self.revoke_tokens(jwt['user']['id'])
                self.delete_cookies
                return self.unauthorized_response
            end
            
            super

            new_token = OauthAccessToken.find_by(previous_refresh_token: refresh_token)
            previous_token = OauthAccessToken.find_by(refresh_token: refresh_token)
            new_token.initial_create = previous_token.initial_create
            new_token.save

            self.revoke_token(OauthAccessToken.find_by(refresh_token: refresh_token))
        elsif
            user_id = User.find_by(email: params[:email])
            self.revoke_tokens(user_id)
            super
            token = OauthAccessToken.where(resource_owner_id: user_id).last
            token[:initial_create] = token[:created_at]
            token.save
        end
    end

    def sign_out
        self.delete_cookies
        self.revoke_tokens(self.decode_jwt(request.cookies['tokens']))
    end

    private

    def can_refresh(tokens)
        return true if OauthAccessToken.find_by(token: JSON.parse(tokens)['jwt'])[:initial_create].to_i > (Time.current.utc - 13.hours).to_i
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

    def revoke_tokens(user_id)
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