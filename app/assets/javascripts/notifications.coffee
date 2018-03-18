document.addEventListener 'turbolinks:load', ->
  $('#notification-form').submit (event) ->
    $('#notification-rules').val(rules2JSON())
    return true

  # init sliders for rules
  $('div.range-slider').each ->
    e = $(this)
    val = e.data('value').split(',')
    unit = e.data('unit')
    digits = e.data('digits')

    # init sliders
    noUiSlider.create this,
      start: val,
      connect: true,
      tooltips: [unitFormatter(unit, digits), unitFormatter(unit, digits)],
      range:
        'min': e.data('min'),
        'max': e.data('max')
      pips:
        mode: 'positions',
        values: [0,25,50,75,100],
        density: 2,
        stepped: true

    # save value if slider was moved
    slider = this.noUiSlider
    slider.on 'set', ->
      val_s = slider.get()
      e.next('input.rule-value').val(val_s.join(','))

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

@unitFormatter = (unit, dec_places) ->
  dec_places = 10 ** dec_places
  return {
    to: (v) -> Math.round(v * dec_places) / dec_places + unit,
    from: (v) -> Math.round(v * dec_places) / dec_places + unit
  }

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
