document.addEventListener 'turbolinks:load', ->
  $('#notification-form').submit (event) ->
    $('#notification-rules').val(rules2JSON())
    return true

  # init sliders for rules
  $('div.range-slider').each ->
    e = $(this)
    vals = e.data('value').split(',')
    unit = e.data('unit')
    digits = e.data('digits')

    # init sliders
    noUiSlider.create this,
      start: vals,
      connect: true,
      tooltips: [unitFormatter('', unit, digits), unitFormatter('', unit, digits)],
      range:
        'min': e.data('min'),
        'max': e.data('max')
      pips:
        mode: 'positions',
        values: [0, 25, 50, 75, 100],
        density: 2,
        stepped: true

    # save value if slider was moved
    slider = this.noUiSlider
    slider.on 'set', ->
      vals = slider.get()
      e.next('input.rule-value').val(vals.join(','))

  # init sliders for rules
  $('div.cardinal-direction').each ->
    e = $(this)
    val = e.data('value')
    unit = e.data('unit')
    digits = e.data('digits')
    type = if e.attr('id').endsWith('from') then 'from' else 'to'

    # init sliders
    noUiSlider.create this,
      start: val,
      tooltips: unitFormatter(type + ' ', unit, digits),
      range:
        'min': e.data('min'),
        'max': e.data('max')
      pips:
        mode: 'positions',
        values: [0, 25, 50, 75, 100],
        format: cardinalDirFormatter(),
        density: 2,

    # build and save value if slider was moved
    slider = this.noUiSlider
    slider.on 'set', ->
      # get other slider
      other_slider = document.getElementById(e.data('sibling')).noUiSlider
      # get value
      vals = [slider.get(), other_slider.get()]
      # if this is the second slider reverse values
      if type == 'to'
        vals = vals.reverse()
      # set new value
      e.siblings('input.rule-value').first().val(vals.join(','))

  # init toggle matches
  $('.toggle-matches').click ->
    e = $(this)
    e.closest('.card').find('.additional-match').toggle()
    e.children('.up').toggle()
    e.children('.down').toggle()
    return false

  $('.activated-check').click ->
    activated = $(this).is(':checked')
    card_parent = $(this).closest('.card')
    card_body = card_parent.children('.card-body')
    if activated
      card_parent.addClass('border-success')
      card_body.slideDown()
    else
      card_parent.removeClass('border-success')
      card_body.slideUp()

@unitFormatter = (prefix, unit, dec_places) ->
  dec_places = 10 ** dec_places
  return {
    to: (v) -> prefix + Math.round(v * dec_places) / dec_places + unit,
    from: (v) -> prefix + Math.round(v * dec_places) / dec_places + unit
  }

@cardinalDirFormatter = ->
  return {
    to: mapCardinalDir
    from: mapCardinalDir
  }

mapCardinalDir = (v) ->
  v = parseFloat(v)
  if v > 45 && v <= 135
    return 'E'
  else if v > 135 && v <= 225
    return 'S'
  else if v > 225 && v <= 315
    return 'W'
  else
    return 'N'

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
