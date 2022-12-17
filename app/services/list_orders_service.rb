require 'json'
class ListOrdersService < ApplicationService
    attr_reader :list_orders
    def initialize
        @list_orders = list_orders
    end 

    def call
        process_orders
    end

    private

    def process_orders
        list_orders = []
        orders = SalesOrder.where.not(order_status: 'closed').order('last_modified_at DESC').limit(100)
        orders.each do |order|
            list_orders << {
                id: order.id,
                order_number: order.order_number,
                customer_id: order.customer_id,
                sales_order_internal_id: order.sales_order_internal_id,
                order_status: order.order_status,
                check_date: order.check_date,
                previous_check_date: order.previous_check_date,
                order_date: order.order_date,
                ship_date: order.ship_date,
                delivery_date: order.delivery_date,
                delivered_date: order.delivered_date,
                price: order.price,
                quantity_fulfilled: order.quantity_fulfilled,
                ns_status: order.ns_status,
                bo_status: order.bo_status,
                last_modified_at: order.last_modified_at
            }
        end
        list_orders = JSON.parse(list_orders.to_json).to_s.gsub('=>', ':')
        list_orders
    end
end
    