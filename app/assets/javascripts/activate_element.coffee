document.addEventListener 'turbolinks:load', ->
  $('input#activate-element').on 'click', ->
    e = $(this)
    target = e.data('target')
    $(target).prop('disabled', !e.prop('checked'))

