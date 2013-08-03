json.photos @photos do |photo|
  json.id photo.id
  json.thumbnail_url photo.thumbnail_url
  json.fullsize_url photo.fullsize_url
  json.message photo.message
  json.posted_at photo.posted_at
end

json.page params[:page]
json.all_count @all_count
