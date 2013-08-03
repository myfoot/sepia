# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

apply_unveil = (target) ->
  if target?
    $(target).unveil(0)
  else
    $('img.img-photo').unveil(0)

apply_unveil()

$('#load-link').bind 'click', ->
  $link = $(this);
  currentPage = $link.attr('data-current-page') - 0
  $.get($link.data('url'), page: currentPage+1)
  .done (data) ->
    parent = $('#photos #polaroids')
    template = _.template($('#photo-template').html());
    _.each data.photos, (photo, i) ->
      $(parent).append(template(url: photo.thumbnail_url, message: photo.message, page: data.page))
    apply_unveil("img.img-photo[data-page='#{data.page}']")
    $link.attr 'data-current-page', data.page
    $link.hide() if data.page * 50 >= data.all_count
