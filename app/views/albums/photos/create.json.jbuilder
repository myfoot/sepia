if !@photos or @photos.empty?
  response.status = 400
  json.result :failed
  json.message 'invalid photo id'
elsif @error
  response.status = 400
  json.result :failed
  json.message @error.to_s
else
  json.result :success
end

json.album_id params[:album_id]
json.photo_ids params[:photo_ids]

