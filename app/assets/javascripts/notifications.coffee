document.addEventListener 'turbolinks:load', ->
  $('#notification-form').submit (event) ->
    $('#notification-rules').val(rules2JSON())
    return true

  # init sliders for rules
  $('.range-slider').each ->
    e = $(this)
    val = e.data('value').split(',')

    noUiSlider.create this,
      start: val,
      connect: true,
      tooltips: true,
      format: { to: Math.round, from: Math.round }
      range:
        'min': e.data('min'),
        'max': e.data('max')
      pips:
        mode: 'range',
        values: e.data('values')

# convert rules to json in order to send them to the backend
@rules2JSON = ->
  obj = {}
  $('.rule').each ->
    field = $(this).find('input.rule-value,select.rule-value').first()
    name = field.attr('id')
    activated = $('input#' + name + '_activated').is(':checked')
    obj[name] = {}
    obj[name]['value'] = field.val()
    obj[name]['activated'] = activated
    true # coffee script automatically returns last value, activated = false would break the loop
  return JSON.stringify(obj)
