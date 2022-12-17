class Api::V1::BackofficeController < ApplicationController
    before_action :authenticate_user!
    
    def index
        render json: { message: 'Hello from Backoffice' }
    end

    def new 
        @order = Order.new
    end

    def create 
        @order = Order.new(order_params)
        if @order.save
            redirect_to @order
        else
            render 'new'
        end
    end

    def show
        @order = Order.find(params[:id])
    end

    def edit
        @order = Order.find(params[:id])
    end

    def update
        @order = Order.find(params[:id])
        if @order.update(order_params)
            redirect_to @order
        else
            render 'edit'
        end
    end

    def destroy
        @order = Order.find(params[:id])
        @order.destroy
        redirect_to orders_path
    end

    private

    def order_params
        params.require(:order).permit(:name, :description, :price, :image)
    end
end