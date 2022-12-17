require 'faker'

30.times do 
    SalesOrder.create(
        order_status: ['pending', 'processing', 'shipped', 'delivered', 'closed'].sample,
        order_number: Faker::Number.number(digits: 7),
        customer_id: Faker::Number.number(digits: 7),
        sales_order_internal_id: Faker::Number.number(digits: 7),
        creation_params: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
        check_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        previous_check_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        order_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        ship_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        delivery_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        delivered_date: Faker::Date.between(from: 1.year.ago, to: Date.today),
        price: Faker::Number.decimal(l_digits: 2).to_f,
        quantity_fulfilled: Faker::Number.decimal(l_digits: 2).to_f,
        ns_status: ['open', 'Missed', 'Complete'].sample,
        bo_status: [1, 2, 3, 4, 5, 6, 7].sample,
        last_modified_at: Faker::Date.between(from: 1.year.ago, to: Date.today)
    )
    end
