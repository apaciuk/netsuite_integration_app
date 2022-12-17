# == Schema Information
#
# Table name: sales_orders
#
#  id                      :uuid             not null, primary key
#  bo_status               :integer          default(0), not null
#  check_date              :datetime         not null
#  creation_params         :jsonb            not null
#  delivered_date          :datetime
#  delivery_date           :datetime
#  last_modified_at        :datetime         not null
#  ns_status               :integer          default("pending"), not null
#  order_date              :datetime         not null
#  order_number            :integer          not null
#  order_status            :integer          not null
#  previous_check_date     :datetime         not null
#  price                   :float            default(0.0), not null
#  quantity_fulfilled      :float            default(0.0), not null
#  ship_date               :datetime         not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  customer_id             :integer          not null
#  sales_order_internal_id :integer
#
require 'rails_helper'

RSpec.describe SalesOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
