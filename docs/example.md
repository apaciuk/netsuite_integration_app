  def initialize(params)
    @params = params
  end

  def call
    orders = Order.all

    orders = orders.where(status: @params[:status]) if @params[:status].present?
    orders = orders.where('created_at >= ?', @params[:from]) if @params[:from].present?
    orders = orders.where('created_at <= ?', @params[:to]) if @params[:to].present?

    orders
  end
end

# Path: app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def index
    @orders = ListOrdersService.new(params).call
  end
end

# Path: app/views/orders/index.html.erb
<%= form_tag orders_path, method: :get do %>
  <%= select_tag :status, options_for_select(Order.statuses.keys, params[:status]) %>
  <%= date_field_tag :from, params[:from] %>
  <%= date_field_tag :to, params[:to] %>
  <%= submit_tag 'Search' %>
<% end %>

<% @orders.each do |order| %>
  <p><%= order.status %></p>
<% end %>

In this example, we are using the ApplicationService class to create a new service. We are passing the params from the controller to the service and using them to filter the orders. We are using the call method to return the orders.

The service is called from the controller and the result is assigned to the @orders variable. The @orders variable is used in the view to display the orders.

The service is a simple class that has a single responsibility. It is responsible for filtering the orders based on the parameters passed to it. The controller is responsible for calling the service and passing the parameters. The view is responsible for displaying the orders.

This is a very simple example, but it shows how to use services in a Rails application.

Conclusion

Services are a great way to organize your code. They are simple classes that have a single responsibility. They are easy to test and easy to reuse.
