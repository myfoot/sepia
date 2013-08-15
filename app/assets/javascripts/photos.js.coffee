# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('body').popover(selector: 'div[class=polaroid]', trigger: 'hover')

truncate_message = (parent) ->
  polaroids = if parent? then $('.polaroid .message', parent) else $('.polaroid .message')
  polaroids.each ->
    $(this).trunk8()
    if $(this).attr('title')?
      $(this).addClass('message-truncate')
      $(this).on 'click', ->
        trunkOption = if $(this).attr('title') == $(this).text() then '' else 'revert'
        $(this).css('visibility', 'hidden')
        $(this).css('opacity', 0.0)
        $(this).css('visibility', 'visible').animate(opacity: 1.0, 200)
        $(this).trunk8(trunkOption)

truncate_message()

apply_unveil = (target) ->
  if target?
    $(target).unveil(0)
  else
    $('img.img-photo').unveil(0)

apply_unveil()

$('#load-link').bind 'click', ->
  $link = $(this)
  currentPage = $link.attr('data-current-page') - 0
  $.get($link.data('url'), page: currentPage+1)
  .done (data) ->
    parent = $('#photos #polaroids')
    template = _.template($('#photo-template').html())
    polaroids = ""
    _.each data.photos, (photo, i) ->
      polaroids += template(url: photo.thumbnail_url, message: photo.message, page: data.page, posted_at: photo.posted_at)

    polaroidsObj = $(polaroids)
    $(parent).append(polaroidsObj)
    polaroidsObj.each -> truncate_message($(this))

    apply_unveil("img.img-photo[data-page='#{data.page}']")
    $link.attr 'data-current-page', data.page
    $link.hide() if data.page * 50 >= data.all_count
