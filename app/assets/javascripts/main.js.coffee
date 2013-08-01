$ ->
  $('#side-menu').on 'mouseover', ->
    $('#side-menu').animate {width:'150px'}, {queue: false}

  $('#side-menu').on 'mouseout', ->
    $('#side-menu').animate {width:'50px'}, {queue: false}
