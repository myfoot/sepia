json.albums @albums do |album|
  json.id album.id
  json.url url_for(album)
  json.image_url album.photos.empty? ? '/images/no-image.jpg' : album.photos.first.thumbnail_url
  json.name album.name
  json.size album.photos.size
  json.updated_at format_time(album.updated_at)
end

json.page params[:page]
json.all_count @all_count

