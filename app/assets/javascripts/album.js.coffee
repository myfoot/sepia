
class Album
  constructor: (id) ->
    @id = id

  show_url: =>
    "/albums/#{@id}"

  update: (name) =>
    $.ajax(type: 'PUT', url: "/albums/#{@id}.json", data: { album: { name: name } }, dataType: 'json')

  delete: =>
    $.ajax(type: 'DELETE', url: "/albums/#{@id}.json", dataType: 'json')

  delete_photos: (photo_ids) =>
    $.ajax
      type: 'DELETE',
      url: "/albums/#{@id}/photos.json",
      data: {photo_ids: photo_ids}
      dataType: 'json'
      timeout: 10000,

this.Album = Album
