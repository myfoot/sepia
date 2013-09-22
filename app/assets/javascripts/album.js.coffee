
class Album
  constructor: (id) ->
    @id = id

  show_url: =>
    "/albums/#{@id}"

  update: (name) =>
    $.ajax(type: 'PUT', url: "/albums/#{@id}.json", data: { album: { name: name } }, dataType: 'json')

  delete_photos: (token, photo_ids) =>
    $.ajax
      type: 'DELETE',
      url: "/albums/#{@id}/photos.json",
      data: {authenticity_token: token,  photo_ids: photo_ids}
      dataType: 'json'
      timeout: 10000,

this.Album = Album
