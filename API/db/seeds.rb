# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Doorkeeper::Application.count.zero? 
    Doorkeeper::Application.create(name: "Web client", redirect_uri: "", scopes: "")
    Doorkeeper::Application.create(name: "React client", redirect_uri: "", scopes: "")
    Doorkeeper::Application.create(name: "Android client", redirect_uri: "", scopes: "")
    Doorkeeper::Application.create(name: "iOS client", redirect_uri: "", scopes: "")
end

if !Role.exists?(1)
    Role.create(name: "admin", description: "Administrator")
end

if !Role.exists?(2)
    Role.create(name: "patient", description: "Has acess to their own examinatiosn and perscriptions.")
end

if !Role.exists?(3)
    Role.create(name: "doctor", description: "Has the ability to create and delete examinations and perscriptions.")
end

if User.find_by(first_name: 'test') == nil 
    i = 0

    while i < 20
        User.create(email: "testPatient#{i}@test.com", password: "123456", 
            first_name: "test", last_name: "patient ##{i}", 
            address: "Test Street #{i}", date_of_birth: Time.current.utc, role_id: 2)

        i += 1
    end
end

if User.find_by(first_name: 'admin') == nil 
        User.create(email: "admin@test.com", password: "123456", 
            first_name: "admin", last_name: "admin", 
            address: "Admin Street", date_of_birth: Time.current.utc, role_id: 1)
end

if User.find_by(first_name: 'doctor') == nil 
    User.create(email: "doctor@test.com", password: "123456", 
        first_name: "doctor", last_name: "doctor", 
        address: "Doctor Street", date_of_birth: Time.current.utc, role_id: 3)
end

if !Drug.any?
    Drug.create(name: 'Paracetamol', description: 'Treats mild fever.')
    Drug.create(name: 'Peroxide', description: 'Desinfectant')
end

unless Examination.any?
    Examination.create(user_id: 1, weight_kg: 80, height_cm: 180, anamnesis: 'test')
end