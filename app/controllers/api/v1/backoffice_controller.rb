class Api::V1::BackofficeController < ApplicationController
    before_action :authenticate_user!
    
    def index
        render json: { message: 'Hello from Backoffice' }
    end
end