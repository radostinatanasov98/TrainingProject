# frozen_string_literal: true

class TokensController < Doorkeeper::TokensController
  def create
    if params[:grant_type] == 'refresh_token'
      return unauthorized_response if request.cookies['tokens'] == ''

      tokens = if request.headers['User-App'] == 'UserApp'
                 request.headers['tokens']
               else
                 request.cookies['tokens']
               end

      jwt = decode_jwt(tokens)
      refresh_token = JSON.parse(tokens)['refresh_token']

      unless can_refresh(tokens)
        revoke_tokens(jwt['user']['id'])
        delete_cookies
        return unauthorized_response
      end

      super

      new_token = OauthAccessToken.find_by(previous_refresh_token: refresh_token)
      previous_token = OauthAccessToken.find_by(refresh_token:)
      new_token.initial_create = previous_token.initial_create
      new_token.save

      revoke_token(OauthAccessToken.find_by(refresh_token:))
    elsif user_id = User.find_by(email: params[:email])
      revoke_tokens(user_id)
      super
      token = OauthAccessToken.where(resource_owner_id: user_id).last
      token[:initial_create] = token[:created_at]
      token.save
    end
  end

  def sign_out
    delete_cookies
    revoke_tokens(decode_jwt(request.cookies['tokens']))
  end

  private

  def can_refresh(tokens)
    if OauthAccessToken.find_by(token: JSON.parse(tokens)['jwt'])[:initial_create].to_i > (Time.current.utc - 13.hours).to_i
      true
    end
  end

  def decode_jwt(tokens)
    JWT.decode(JSON.parse(tokens)['jwt'], nil, false)[0]
  end

  def unauthorized_response
    render(json: { error: 'Unauthorized.' }, status: 401)
  end

  def delete_cookies
    cookie_args = [
      'tokens=',
      'Path=/',
      'HttpOnly',
      "Expires= #{Time.current.utc.to_fs(:rfc822)}"
    ]

    cookie = cookie_args.join('; ')
    response.headers['Set-Cookie'] = cookie
  end

  def revoke_tokens(user_id)
    tokens = OauthAccessToken.where(resource_owner_id: user_id).and(OauthAccessToken.where(revoked_at: nil))

    tokens.each do |t|
      revoke_token(t)
    end
  end

  def revoke_token(token)
    token.revoked_at = Time.current.utc
    token.save
  end
end
