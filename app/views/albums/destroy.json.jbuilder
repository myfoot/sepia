if @album.valid?
  json.set! :result, :success
else
  response.status = 400
  json.set! :result, :error
  json.errors @album.errors do |key|
    json.set! key, @album.errors[key]
  end
end
