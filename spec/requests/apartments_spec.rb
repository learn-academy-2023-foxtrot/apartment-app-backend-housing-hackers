require 'rails_helper'

RSpec.describe "Apartments", type: :request do
  let(:user) { User.create(
    email: 'sponge@spongebob.com',
    password: 'squarepants',
    password_confirmation: 'squarepants'
    )
  }

  describe "GET /index" do
    it 'gets a list of apartments' do
      apartment = user.apartments.create(
        street: '33rd street',
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
      get '/apartments'

      apartment = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(apartment.first['street']).to eq('33rd street')
    end
  end

  describe "POST /create" do 
    it "Saves a valid entry into the database" do
      apartment_params = {
         apartment: {
            street: '33rd street',
            unit: '24',
            city: 'San Diego',
            state: 'CA',
            square_footage: 400,
            price: '3,500',
            bedrooms: 1,
            bathrooms: 1.5,
            pets: '1',
            image: 'https://images1.apartments.com/i2/3-d6aIBQ3G60q9rMK834i2RTrIMD8b5zCH5GIZy0nFQ/111/vive-luxe-san-diego-ca-building-photo.jpg',
            user_id: user.id
         }
      }

      post '/apartments', params: apartment_params
      apartment = JSON.parse(response.body)
      expect(apartment['state']).to eq 'CA'
      expect(response).to have_http_status(200)
    end
  end  
end