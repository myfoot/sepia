$ ->
  # webkit-perspectiveが設定されているとbootstrapのmodalが裏に隠れてしまう
  # そのためメニューにマウスが乗っていないときはwebkit-perspectiveを消している
  # そしてメニューにマウスが乗ったときは値を戻している
  # なおこの現象はFirefoxでは再現しない
  $('#box-menu').on 'mouseenter', ->
    $('.box-lid').css('webkit-perspective', '')

  $('#box-menu').on 'mouseleave', ->
    setTimeout ->
      $('.box-lid').css(cssText: '-webkit-perspective: none !important')
    , 500

  $('.box-lid').css(cssText: '-webkit-perspective: none !important')
  $('.box-lid-menu').boxLid()
