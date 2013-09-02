# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('body').popover(selector: 'div[class=polaroid]', trigger: 'hover')

truncate_message = (parent) ->
  messages = if parent? then $('.polaroid .message', parent) else $('.polaroid .message')
  messages.each ->
    message = $(this)
    short = $(".message-short", message)
    origin_text = short.text()
    short.trunk8()
    if short.attr('title')?
      message.css('text-align', 'left')
      message.addClass('message-toggle')
      message.width(short.width())
      short_real_length = short.text().length - 1 # truncate '&hellip;'
      message.append('<p class="message-full">' + origin_text.substr(short_real_length) + '</p>')
      message.on 'click', ->
        full = $('.message-full', message)
        if full.css('display') is 'none'
          short.text(short.text().substr(0, short_real_length))
        else
          short.append('&hellip;')
        full.slideToggle('middle')

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
