document.addEventListener 'turbolinks:load', ->
  $('.autocomplete').selectize
    labelField: 'name',
    valueField: 'url',
    searchField: 'name',
    create: false,
    render:
      option: (item, escape) ->
        return '<div>' + item.name + ' - ' + item.country + '</div>'
    load: (query, callback) ->
      if (query.length <= 3)
        return callback()
      $.get '/provider/msw/find/' + encodeURIComponent(query), (data) ->
        callback data
      .fail ->
        callback { name: 'Can not connect to magicseaweed' }
