Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:3001', 'http://usersapp'
      resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete], credentials: true, expose: ['Set-Cookie']
    end
end