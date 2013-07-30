$ ->
  $('#side-menu').on 'mouseover', ->
    $('#side-menu').animate {width:'150px'}, {queue: false}

  $('#contents').on 'mouseover', ->
    $('#side-menu').animate {width:'50px'}, {queue: false}
