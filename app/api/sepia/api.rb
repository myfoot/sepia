module Sepia
  class API < Grape::API
    mount Sepia::API::V1
  end
end
