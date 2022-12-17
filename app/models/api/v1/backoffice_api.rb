class Api::BackofficeApi < ApplicationRecord
	class BackofficeApi < Grape::API
		version 'v1', using: :path
		format :json
		prefix :api

		resource :orders do
		
		end
	end
end

	