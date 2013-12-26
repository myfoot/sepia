$ ->
  $("#user_name").typeahead
    ajax:
      url: "/users.json"
      preDispatch: (query) ->
        $("#user_name").serialize()
      preProcess: (data) ->
        data.users.map (user) -> new UserForTypeahead(user).typeahead_item()
    onSelect: (item) ->
      location.href = "/users/#{item.value}"