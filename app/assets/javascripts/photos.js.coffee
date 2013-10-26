# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('body').popover(selector: 'ul .polaroid', trigger: 'hover')
truncate_message = (parent) ->
  messages = if parent? then $('.polaroid .message', parent) else $('.polaroid .message')
  SepiaUtil.truncate_message(messages)

truncate_message()

apply_unveil = (page) -> $("img.img-photo[data-page='#{page}']").unveil(0)
apply_unveil(1)

apply_fancybox = () -> SepiaUtil.apply_fancybox($('.display-link'))
apply_fancybox()

$('#load-link').bind 'click', ->
  $link = $(this)
  currentPage = $link.attr('data-current-page') - 0
  $.get($link.data('url'), page: currentPage+1)
  .done (data) ->
    parent = $('#photos #polaroids')
    template = _.template($('#photo-template').html())
    polaroids = ""
    _.each data.photos, (photo, i) ->
      polaroids += template(thumbnail_url: photo.thumbnail_url, fullsize_url: photo.fullsize_url, message: photo.message, page: data.page,\
                            posted_at: photo.posted_at, provider: photo.provider, icon_class: photo.icon_class)

    polaroidsObj = $(polaroids)
    $(parent).append(polaroidsObj)
    polaroidsObj.each -> truncate_message($(this))

    apply_unveil(data.page)
    $link.attr 'data-current-page', data.page
    $link.hide() if data.page * 50 >= data.all_count
    apply_fancybox()
