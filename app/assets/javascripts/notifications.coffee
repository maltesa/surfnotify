document.addEventListener 'turbolinks:load', ->
  $('#notification-form').submit (event) ->
    $('#notification-rules').val(rules2JSON())
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

  $('.matching-forecasts').on 'show.bs.collapse', ->
    id = $(this).attr('id')
    btn = $('button[data-target="#' + id + '"]')
    icon = btn.children('i').first()
    icon.removeClass('fa-chevron-right')
    icon.addClass('fa-chevron-down')

  $('.matching-forecasts').on 'hidden.bs.collapse', ->
    id = $(this).attr('id')
    btn = $('button[data-target="#' + id + '"]')
    icon = btn.children('i').first()
    icon.removeClass('fa-chevron-down')
    icon.addClass('fa-chevron-right')

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
