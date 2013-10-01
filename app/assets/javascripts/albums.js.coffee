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

apply_delete = ($link, $promise) ->
  $link.css('display', 'none')
  $promise
  .done (data) ->
    $link.closest('li').animate width: 'hide', height: 'hide', opacity: 'hide', 'slow', -> $(this).remove()
  .fail (res) ->
    # TODO エラー時の見せ方
    console.log(res.responseJSON)
    $link.css('display', '')

do ->
  $('#photos').on 'click', '.photo-trash', ->
    if confirm('Is this photo deleted from an album?')
      $link = $(this)
      apply_delete($link, new Album($link.data('album-id')).delete_photos($link.data('photo-ids')))

do ->
  $('#albums').on 'click', '.album-trash', ->
    if confirm('Is this album deleted?')
      $link = $(this)
      apply_delete($link, new Album($link.data('album-id')).delete())

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
      .update(name: text.val())
      .done (data) ->
        title.html text.val()
      .always ->
        text.off('keypress.title-edit').hide()
        header.fadeIn()

load_candidates = (page, done_handler) ->
  $.get($('#add-candidate').data('url'), page: page)
  .done (data) ->
    parent = $('#candidate-photos')
    template = _.template($('#candidate-template').html())
    candidate_photos = ''
    _.each data.photos, (photo, i) ->
      candidate_photos += template(id: photo.id, page: data.page, thumbnail_url: photo.thumbnail_url)
    $(parent).append(candidate_photos)
    $("#add-candidate img[data-candidate-page='#{data.page}']").unveil(0)
    done_handler(data) if done_handler

$('#load-candidate-link').on 'click', ->
  $link = $(this)
  currentPage = $link.attr('data-current-page') - 0
  load_candidates(currentPage + 1, (data) ->
    $link.attr 'data-current-page', data.page
    # TODO '50'のベタ書き。photos.coffeeにもあるが、Settingsを参照したい
    $link.hide() if data.page * 50 >= data.all_count
  )

$('#toggle-candidate').on 'click', ->
  $candidate = $('#add-candidate')
  $candidate.animate(height: 'toggle', 500, 'swing', ->
    text = if $candidate.css('display') == 'none' then 'Add photo' else 'Close'
    $('#toggle-candidate').html(text)
  )

do ->
  mimeType = 'text/plain'
  dragImgCssClass = 'drag-img-active'
  dropCssClass = 'drop-area-notice'
  $dragArea = $('#add-candidate')
  $dropArea = $('#photos')

  $dragArea.on 'dragstart', 'img', (event) ->
    $(this).addClass(dragImgCssClass)
    $dropArea.addClass(dropCssClass)
    event.originalEvent.dataTransfer.setData(mimeType, $(this).data('photo-id'))

  $dragArea.on 'dragend', 'img', (event) ->
    $(this).removeClass(dragImgCssClass)
    $dropArea.removeClass(dropCssClass)

  $dropArea.on 'dragover', (event) ->
    event.preventDefault()

  $dropArea.on 'drop', (event) ->
    new Album($(this).data('album-id'))
    .add_photos([event.originalEvent.dataTransfer.getData(mimeType)])
    .done (data) ->
      $.toast('Photo was added.', duration: 3000, type: 'success')
    .fail (res) ->
      $.toast('Photo was not able to add.', duration: 5000, type: 'danger')
    .always ->
      $($dragArea, 'img').removeClass(dragImgCssClass)
      $(this).removeClass(dropCssClass)
    event.preventDefault()

$('#album-visibility').on 'switch-change', (e, data) ->
  $switch = $(this);
  new Album($switch.data('album-id'))
  .update(public: data.value)
  .fail (res) ->
    alert('failed to update visibility')
    
