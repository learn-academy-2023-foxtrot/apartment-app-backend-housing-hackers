# README

```git
$ rails new apartment-app-backend -d postgresql -T
$ cd apartment-app-backend
$ rails db:create
$ bundle add rspec-rails
$ rails generate rspec:install
$ rails server
```

Add the remote from your GitHub classroom repository
Create a default branch (main)
Make an initial commit to the repository
Ask your instructors for branch protection

Added Devise
```git
  $ bundle add devise
  $ rails generate devise:install
  $ rails generate devise User
  $ rails db:migrate
```

Added JWT inside of the Gemfile
  gem 'devise-jwt'
  gem 'rack-cors'

CORS setup
config/initializers/cors.rb
```rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource '*',
    headers: ["Authorization"],
    expose: ["Authorization"],
    methods: [:get, :post, :put, :patch, :delete, :options, :head],
    max_age: 600
  end
end
```

Generate the apartment resource
```git
rails generate resource Apartment street:string unit:string city:string state:string square_footage:integer price:string bedrooms:integer bathrooms:float pets:string image:text user_id:integer
<!-- Then db migrate! -->
```

Defined relationships
```rb
# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :apartments
end

//app/models/apartment.rb
class Apartment < ApplicationRecord
  belongs_to :user
end
```

Then added seeds!
```rb
user1 = User.where(email: "sponge@spongebob.com").first_or_create(password: "squarepants", password_confirmation: "squarepants")
user2 = User.where(email: "patrick@patrick.com").first_or_create(password: "patrick", password_confirmation: "patrick")


apt1 = [
    {
      street: '33rd street',
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1'
    
    },
    {
        street: '1234th middle view street',
        unit: '40b',
        city: 'Springfield',
        state: 'CA',
        square_footage: 2700,
        price: '4,500',
        bedrooms: 5,
        bathrooms: 3.5,
        pets: '1'
    
    }
]

apt2 = [
    {
        street: 'Main street',
        unit: '75',
        city: 'Anaheim',
        state: 'CA',
        square_footage: 1200,
        price: '2,000',
        bedrooms: 2,
        bathrooms: 2.5,
        pets: '2'
    },
    {
        street: 'West street',
        unit: '2C',
        city: 'Long Island',
        state: 'NY',
        square_footage: 1300,
        price: '3,600',
        bedrooms: 2,
        bathrooms: 1.5,
        pets: 'none'
     
    }
]

apt1.each do |apartment| 
    user1.apartments.create(apartment)
    p "creating #{apartment}"
end

apt2.each do |apartment| 
    user2.apartments.create(apartment)
    p "creating #{apartment}"
end
```

Then we did additional devise configurations
```rb
# config/environemnts/development/.rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

#Then 
# Find this line:
config.sign_out_via = :delete
# And replace it with this:
config.sign_out_via = :get
# Uncomment the config.navigational_formats line and remove the contents of the array:
config.navigational_formats = []


#Then
# Next we want to create registrations and sessions controllers to handle signups and logins.
$ rails g devise:controllers users -c registrations sessions

#Then replace the contents of these controllers with the following code:

#app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    build_resource(sign_up_params)
    resource.save
    sign_in(resource_name, resource)
    render json: resource
  end
end

#app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    render json: resource
  end
  def respond_to_on_destroy
    render json: { message: "Logged out." }
  end
end

#Lastly, we need to update the devise routes: config/routes.rb
Rails.application.routes.draw do
  resources :apartments
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
end
```

Then we did the JWT Secret Key Configuration
```git
$ bundle exec rake secret (We get the secret key)
$ EDITOR="code --wait" bin/rails credentials:edit (gets us the JWT new key)
```
In the config/credentials.yml.enc this should pop up when running last code! 
```git
# aws:
#   access_key_id: 123
#   secret_access_key: 345

# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: (key)
```
Now we can add our new secret at the bottom of this file by assigning it to a key jwt_secret_key:
```rb
jwt_secret_key: <newly-created secret key>
```
Then save file by doing control + c or closing vs code.

Configure Devise and JWT
```rb
# config/initializers/devise.rb
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.jwt_special_key
  jwt.dispatch_requests = [
    ['POST', %r{^/login$}],
  ]
  jwt.revocation_requests = [
    ['DELETE', %r{^/logout$}]
  ]
  jwt.expiration_time = 5.minutes.to_i
end
```

Revocation with JWT
```git
$ rails generate model jwt_denylist
```
```rb
# inside new migration file that is created when running code from above
def change
  create_table :jwt_denylist do |t|
    t.string :jti, null: false
    t.datetime :exp, null: false
  end
  add_index :jwt_denylist, :jti
end
# db migrate!
```

Include revocation
```rb
# app/models/user.rb
devise  :database_authenticatable, :registerable,
        :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
```
Then we validated all the entries that a user can input to create a new apartment listing. 
```rb
require 'rails_helper'

RSpec.describe Apartment, type: :model do
  let(:user) { User.create(
    email: 'sponge@spongebob.com',
    password: 'squarepants',
    password_confirmation: 'squarepants'
    )
  }
  it 'should validate the street' do
    apartment = user.apartments.create(
      street: nil,
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:street]).to include("can't be blank")
  end
  it 'should validate the unit' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: nil,
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:unit]).to include("can't be blank")
  end
  it 'should validate the city' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: nil,
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:city]).to include("can't be blank")
  end
  it 'should validate the state' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: 'San Diego',
      state: nil,
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:state]).to include("can't be blank")
  end
  it 'should validate the square footage' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: nil,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:square_footage]).to include("can't be blank")
  end
  it 'should validate the price' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: nil,
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:price]).to include("can't be blank")
  end
  it 'should validate the bedroom' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: nil,
      bathrooms: 1.5,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:bedrooms]).to include("can't be blank")
  end
  it 'should validate the bathrooms' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: nil,
      pets: '1',
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:bathrooms]).to include("can't be blank")
  end
  it 'should validate the pets' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: nil,
      image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'
    )
    expect(apartment.errors[:pets]).to include("can't be blank")
  end
  it 'should validate the image' do
    apartment = user.apartments.create(
      street: '33rd Street',
      unit: '24',
      city: 'San Diego',
      state: 'CA',
      square_footage: 400,
      price: '3,500',
      bedrooms: 1,
      bathrooms: 1.5,
      pets: '1',
      image: nil
    )
    expect(apartment.errors[:image]).to include("can't be blank")
  end
end
```

   image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg'  

        image: 'https://images.unsplash.com/photo-1554995207-c18c203602cb?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fDI3MDAlMjBzcSUyMGZ0JTIwYXBhcnRtZW50cyUyMHJvb21zfGVufDB8fDB8fHww'  

          image: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjd8fDI3MDAlMjBzcSUyMGZ0JTIwYXBhcnRtZW50cyUyMHJvb21zfGVufDB8fDB8fHww' 

            image: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzd8fDI3MDAlMjBzcSUyMGZ0JTIwYXBhcnRtZW50cyUyMHJvb21zfGVufDB8fDB8fHww' 


Create Functionality:
  Added the strong params
  Created the API Endpoints
  Made the Create functionality test
  
 







key issues:
$ run bundle(depends on driver)
$ rails db:setuo
$ EDITOR="code --wait" bin/rails credentials:edit
vs code will ask to access yml credentials, enter "yes"
$ ctrl + c
$ restart vs code 