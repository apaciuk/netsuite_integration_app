require 'faker'

30.times do 
    SalesOrder.create(
        order_status: SalesOrder.order_statuses.keys.sample,

    )
