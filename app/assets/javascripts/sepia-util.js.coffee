class SepiaUtil
  truncate_message: ($messages) ->
    $messages.each ->
      $message = $(this)
      $short = $(".message-short", $message)
      origin_text = $short.text()
      $short.trunk8(lines: 2)
      if $short.attr('title')?
        $message.css('text-align', 'left')
        $message.addClass('message-toggle')
        $message.width($short.width())
        short_real_length = $short.text().length - 1 # truncate '&hellip;'
        $message.append('<p class="message-full">' + origin_text.substr(short_real_length) + '</p>')
        $message.on 'click', ->
          $full = $('.message-full', $message)
          if $full.css('display') is 'none'
            $short.text($short.text().substr(0, short_real_length))
          else
            $short.append('&hellip;')
          $full.slideToggle('middle')

  apply_fancybox: ($target) ->
    $target.fancybox(type: 'image', speedIn: 800, speedOut: 200, titlePosition: 'inside', cyclic: true)

this.SepiaUtil = new SepiaUtil()
