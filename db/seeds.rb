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

