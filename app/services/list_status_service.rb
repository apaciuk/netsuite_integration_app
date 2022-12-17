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
        status = SalesOrder.select(:order_status).distinct
        status.each do |status|
            list_status << {
                order_status: status.order_status
            }
        end
        list_status = JSON.parse(list_status.to_json).to_s.gsub('=>', ':')
        list_status
    end

end