
class Album
  constructor: (id) ->
    @id = id

  show_url: =>
    "/albums/#{@id}"

  update: (name) =>
    $.ajax(type: 'PUT', url: "/albums/#{@id}.json", data: { album: { name: name } }, dataType: 'json')

this.Album = Album