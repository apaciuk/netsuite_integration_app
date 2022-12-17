require 'netsuite'
require 'json'
require 'faraday'
require 'faraday_middleware'
attr_reader :update_all_orders
# Constants
PREFIX = "<?xml version=\"1.0\" encoding="UTF-8"?>" + "<supplier>" + "<supplier_id>#{ENV['SUPPLIER_ID']}</supplier_id>" 
+ "<supplier_password>#{ENV['SUPPLIER_PASSWORD']}</supplier_password>" + "<supplier_key>#{ENV['SUPPLIER_KEY']}</supplier_key>"
+ "<supplier_secret>#{ENV['SUPPLIER_SECRET']}</supplier_secret>" + "<supplier_token>#{ENV['SUPPLIER_TOKEN']}</supplier_token>" 
+ "<supplier_token_secret>#{ENV['SUPPLIER_TOKEN_SECRET']}</supplier_token_secret>".freeze
SUFFIX = "</supplier>".freeze
CONNECTION = Faraday.new(url: ENV['BO_URL']) do |faraday|
    faraday.request :url_encoded
    faraday.request :form_multipart 
    faraday.response :logger
    faraday.adapter Faraday.default_adapter
end
class UpdateAllService < ApplicationService 

    def initialize
        @update_all_orders = update_all_orders
    end 

    def call
        process_updates
    end 

    private

    def process_updates
        update_all_orders = []
        bo_update = ListOrdersService.new.call
        if bo_update.present? 
            bo_update.each do |item|
                netsuite_sales_order = NetSuite::Records::SalesOrder.get(sales_order_internal_id: item['order_number'])
                netsuite_sales_order >> {
                    sales_order_internal_id: netsuite_sales_order.sales_order_internal_id,
                    order_status: netsuite_sales_order.order_status,
                    check_date: item['check_date'],
                    previous_check_date: item['previous_check_date'],
                    order_date: item['order_date'],
                    ship_date: netsuite_sales_order.ship_date,
                    delivery_date: netsuite_sales_order.custom_fields_list.custom_fields.select { |field| field.script_id == 'custbody_delivery_date' }.map { |field| field.value }.first,
                    delivered_date: netsuite_sales_order.custom_fields_list.custom_fields.select { |field| field.script_id == 'custbody_delivered_date' }.map { |field| field.value }.first,
                    quantity_fulfilled: netsuite_sales_order.items_list.items.quantity_fulfilled.to_f,
                    ns_status: netsuite_sales_order.custom_fields_list.custom_fields.select { |field| field.script_id == 'custbody_rpod_status' }.map { |field| field.value }.first,
                    last_modified_at: netsuite_sales_order.last_modified_date,
                }
            end
            update_all_orders = JSON.parse(bo_update.to_json).to_s.gsub('=>', ':')
            update_internal_db(update_all_orders)
        else 
            puts "No updates found"
        end
    process_all_orders 
    process_closed_orders 
    end   

    def update_internal_db(update_all_orders)
        current_time = Time.now
        update_all_orders.each do |item|
            sales_order = SalesOrder.find_by(sales_order_internal_id: item['order_number'])
            sales_order.update(
                order_status: item['order_status'],
                check_date: current_time,
                previous_check_date: item['check_date'],
                order_date: item['order_date'],
                ship_date: item['ship_date'],
                delivery_date: item['delivery_date'],
                delivered_date: item['delivered_date'],
                quantity_fulfilled: item['quantity_fulfilled'],
                order_status: item['order_status'],
                ns_status: item['ns_status'],
                last_modified_at: item['last_modified_at']
            )
        end
        update_bo_status 
    end 

    def update_bo_status
        update = SalesOrder.where('last_modified_at > previous_check_date').order('last_modified_at DESC').where.not(order_status: 'closed')
        update.where(order_status: 'pending').where(delivery_date: nil).update_all(bo_status: 1) # Pending
        update.where(order_status: 'processing').where.not(delivery_date: nil).update_all(bo_status: 3) # Processing
        update.where(order_status: 'processing').where.not(delivery_date: nil).where.not(delivered_date: nil).update_all(bo_status: 4) # Delivered
        update.where(order_status: 'processing').where.not(delivery_date: nil).where(delivered_date: nil).where(ns_status: "Missed").update_all(bo_status: 5) # Missed
        update.where.not(quantity_fulfilled: nil).where.not(delivery_date: nil).where.not(delivered_date: nil).where(ns_status: "Complete").update_all(bo_status: 6) # Complete&Delivered
    end
end