document.addEventListener 'turbolinks:load', ->
  $('.spot-autocomplete').selectize
    labelField: 'name',
    valueField: 'url',
    searchField: 'name',
    create: false,
    load: (query, callback) ->
      if (query.length <= 3)
        return callback()
      $.get '/provider/msw/find/' + encodeURIComponent(query), (data) ->
        callback data
      .fail ->
        callback { name: 'Can not connect to magicseaweed' }

  # set spotname hidden field
  $('.spot-autocomplete').on 'change', (value) ->
    $('#spot-name').val($('select.spot-autocomplete > option[selected="selected"]').text())
