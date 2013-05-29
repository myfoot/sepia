if @access_token.valid?
  json.set! :result, :success
else
  response.status = 400
  json.set! :result, :error
end
