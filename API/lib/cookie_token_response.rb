module CookieTokenResponse
  def body
    super.except('access_token', 'token_type')
  end

  def headers
    cookie_args = [
      "access_token=#{token.token}",
      'Path=/',
      'HttpOnly'
    ]

    cookie = cookie_args.join('; ')

    super.merge({ 'Set-Cookie' => cookie })
  end

  private

  def can_refresh(id)
    tokens = OauthAccessToken
             .where('created_at > ?', Time.current.utc - 13.hours)
             .and(OauthAccessToken.where(resource_owner_id: id))
             .select(:refresh_token, :previous_refresh_token)

    return render json: 'false' if tokens == []

    current_token = tokens.last['refresh_token']

    tokens_hash = {}

    tokens.each do |token|
      tokens_hash[token['refresh_token']] = token['previous_refresh_token']
    end

    current = tokens_hash[current_token]

    while current != ''
      return true if tokens_hash[current].nil?

      current = tokens_hash[current]
    end

    false
  end
end
