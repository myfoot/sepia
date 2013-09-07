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
      append_albums += template(page: data.page, url: album.url, image_url: album.image_url, name: album.name, size: album.size, updated_at: album.updated_at, stack_class: stack_class)
    $(parent).append(append_albums)

    apply_unveil(data.page)
    $link.attr 'data-current-page', data.page
    $link.hide() if data.page * 25 >= data.all_count
