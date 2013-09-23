formId = '#new_album'
submitButtonId = '#create-submit'
modalId = '#create-form'
messageTemplateId = "#error-msg-template"
errorAreaId = "#errors"

$(submitButtonId).bind 'click', (event) ->
  event.preventDefault()
  $(formId).submit()

$(formId).submit (event) ->
  event.preventDefault()

  $form = $(this)
  $submitButton = $(submitButtonId)
  $submitButton.attr 'disabled', true
  $errors = $(errorAreaId)
  $errors.children().remove()

  promise = $.ajax
    url: "#{ $form.attr('action') }.json",
    type: $form.attr('method'),
    data: $form.serialize(),
    timeout: 10000,
    dataType: 'json'

  promise.done (data) ->
    $submitButton.attr 'disabled', false
    $(modalId).modal 'hide'
    setTimeout ->
      window.location.href = new Album(data.id).show_url()
    , 500

  promise.fail (res) ->
    _.each res.responseJSON.errors, (error, i) ->
      template = _.template($(messageTemplateId).html())
      _.each error, (messages, key) ->
        _.each messages, (message) ->
          $(template(key: key, message: message)).hide().appendTo($errors).fadeIn()

  undefined

apply_delete = ($link, $promise, confirm_msg) ->
  if confirm(confirm_msg)
    $link.css('display', 'none')
    $promise
    .done (data) ->
      $link.closest('li').animate width: 'hide', height: 'hide', opacity: 'hide', 'slow', -> $(this).remove()
    .fail (res) ->
      # TODO エラー時の見せ方
      console.log(res.responseJSON)
      $link.css('display', '')

regist_photo_delete_event = ->
  $('.photo-trash').bind 'click', ->
    $link = $(this)
    apply_delete($link, new Album($link.data('album-id')).delete_photos($link.data('photo-ids')), 'Is this photograph deleted from an album?')
regist_photo_delete_event()

regist_album_delete_event = ->
  $('.album-trash').bind 'click', ->
    $link = $(this)
    apply_delete($link, new Album($link.data('album-id')).delete(), 'Is this album deleted?')
regist_album_delete_event()

apply_unveil = (page) -> $(".img-block img[data-page='#{page}']").unveil(0)
apply_unveil(1)

$('#load-link').bind 'click', ->
  $link = $(this)
  currentPage = $link.attr('data-current-page') - 0
  $.get($link.data('url'), page: currentPage+1)
  .done (data) ->
    parent = $('#albums')
    template = _.template($('#album-template').html())
    append_albums = ''
    _.each data.albums, (album, i) ->
      stack_class = if album.size < 1 then 'simple' else 'stack'
      append_albums += template(id: album.id, page: data.page, url: album.url, image_url: album.image_url, name: album.name, size: album.size, updated_at: album.updated_at, stack_class: stack_class)
    $(parent).append(append_albums)

    apply_unveil(data.page)
    regist_album_delete_event()
    $link.attr 'data-current-page', data.page
    $link.hide() if data.page * 25 >= data.all_count


$('.title-edit').on 'click', ->
  album_id = $(this).data('album-id')
  title =  $("#title-#{album_id}")
  header = $("#title-header-#{album_id}")
  header.hide()

  $("#title-edit-#{album_id}")
  .val(title.html())
  .fadeIn()
  .on 'keypress.title-edit', (event) ->
    if event.which == 13
      text = $(this)
      new Album(album_id)
      .update(text.val())
      .done (data) ->
        title.html text.val()
      .always ->
        text.off('keypress.title-edit').hide()
        header.fadeIn()

