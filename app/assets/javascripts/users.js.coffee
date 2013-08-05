# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class User
  constructor: (id) ->
    @id = id
  update: (name, email) =>
    $.ajax(type: 'PUT' , url: "/users/#{@id}.json", data: {user: { name: name, email: email }}, dataType: 'json')
this.User = User

this.UserActions = {
  bindUpdate: (userId, nameEmelemetId, emailElementId) ->
    user = new User(userId)
    updateFunc = ->
      clearTimeout(timer) if timer?
      timer = setTimeout ->
        p = user.update($("##{nameEmelemetId}").val(), $("##{emailElementId}").val())
        p.done (a,b) ->
          console.log(a)
          console.log(b)
          console.log("Success!!!")
        timer = null
      , 1000
    $("##{nameEmelemetId}").change(updateFunc)
    $("##{emailElementId}").change(updateFunc)
}