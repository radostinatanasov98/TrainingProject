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

      unless can_refresh(jwt, refresh_token)
        revoke_tokens(jwt)
        delete_cookies
        return unauthorized_response
      end

      super

      revoke_token(OauthAccessToken.find_by(refresh_token:))

      return
    end

    super
  end

  def sign_out
    delete_cookies
    revoke_tokens(decode_jwt(request.cookies['tokens']))
  end

  private

  def can_refresh(jwt, refresh_token)
    return false if request.cookies['tokens'] == ''

    return false unless OauthAccessToken.find_by(refresh_token:)[:revoked_at].nil?

    user_id = jwt['user']['id']

    tokens = OauthAccessToken
             .where('created_at > ?', Time.current.utc - 13.hours)
             .and(OauthAccessToken.where(resource_owner_id: user_id))
             .select(:refresh_token, :previous_refresh_token)

    return false if tokens == []

    tokens_hash = {}

    tokens.each do |token|
      tokens_hash[token['refresh_token']] = token['previous_refresh_token']
    end

    current = tokens_hash[refresh_token]

    until current.nil?
      return true if current == ''

      current = tokens_hash[current]
    end

    false
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

  def revoke_tokens(jwt)
    user_id = jwt['user']['id']
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
