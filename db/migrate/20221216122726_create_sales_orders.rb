class CreateSalesOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :sales_orders, id: :uuid do |t|
      t.integer :order_status, default: 'pending', null: false
      t.integer :order_number, null: false, unique: true
      t.integer :customer_id, null: false
      t.integer :sales_order_internal_id
      t.datetime :check_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :previous_check_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :order_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :ship_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :delivery_date, null: true # null: true because may not always be available
      t.datetime :delivered_date, null: true # null: true because may not always be available
      t.float :price, null: false, default: 0.0
      t.float :quantity_fulfilled, null: false, default: 0.0
      t.integer :ns_status, null: false, default: 0 
      t.integer :bo_status, null: false, default: 0 
      t.datetime :last_modified_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }


      t.timestamps
    end
  end
end


