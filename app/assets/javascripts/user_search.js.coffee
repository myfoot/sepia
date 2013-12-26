class UserForTypeahead
  constructor: (user) ->
    @id = user.id
    @name = user.name
    @avatar_url = user.avatar_url
  name_with_icon: ->
    $avatar = $('<img>')
      .attr("src", @avatar_url)
      .attr("width", "20px")
      .attr("height", "20px")
      .attr("style", "margin-right: 5px;")
      .addClass("radius-circle")
    $name = $('<div>')
      .append($avatar)
      .append( $('<span>').text(@name) )
    $name.html()
  typeahead_item: ->
    id: @id, name: this.name_with_icon()

this.UserForTypeahead = UserForTypeahead