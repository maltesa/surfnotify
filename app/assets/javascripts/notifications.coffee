document.addEventListener 'turbolinks:load', ->
  $('#notification-form').submit (event) ->
    $('#notification-rules').val(rules2JSON())
    console.log rules2JSON()
    return true

  $('.range-slider').each ->
    e = $(this)
    e.jRange
      from: e.data('from'),
      to: e.data('to'),
      step: 1,
      scale: e.data('scale'),
      format: '%s',
      width: 600,
      showLabels: true,
      isRange : true
  
@rules2JSON = ->
  obj = {}
  $('.rule').each ->
    field = $(this).find('input,select').first()
    name = field.attr('id')
    obj[name] = field.val()
  return JSON.stringify(obj)
