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
