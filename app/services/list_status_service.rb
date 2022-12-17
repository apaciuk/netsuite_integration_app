class ListStatusService < ApplicationService 
    attr_reader :list_status
    def initialize
        @list_status = list_status
    end 

    def call
        process_status
    end

    private

    def process_status
        list_status = []
        status = SalesOrder.where('last_modified_at > previous_check_date').order('last_modified_at DESC').limit(100).where.not(order_status: 'closed')
        status.each do |status|
            list_status << {
                id: status.id,
                order_number: status.order_number,
                customer_id: status.customer_id,
                sales_order_internal_id: status.sales_order_internal_id,
                order_status: status.order_status,
                check_date: status.check_date,
                previous_check_date: status.previous_check_date,
                order_date: status.order_date,
                ship_date: status.ship_date,
                delivery_date: status.delivery_date,
                delivered_date: status.delivered_date,
                price: status.price,
                quantity_fulfilled: status.quantity_fulfilled,
                ns_status: status.ns_status,
                bo_status: status.bo_status,
                last_modified_at: status.last_modified_at
            }
        end
        list_status = JSON.parse(list_status.to_json).to_s.gsub('=>', ':')
        puts "list_status: #{list_status}"
    end

end