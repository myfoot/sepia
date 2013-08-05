
class Album
  constructor: (id) ->
    @id = id

  show_url: =>
    "/albums/#{@id}"

this.Album = Album