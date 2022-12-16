class Apis::BackofficeApi < ApplicationRecord
	class BackofficeApi < Grape::API
		version 'v1', using: :path
		format :json
		prefix :api

		resource :users do
			desc 'Return all users'
			get do
				User.all
			end

			desc 'Return a user'
			params do
				requires :id, type: Integer, desc: 'User id.'
			end
			route_param :id do
				get do
					User.find(params[:id])
				end
			end
		end
	end
end

	