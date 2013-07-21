class pxwrkHelpersForViews extends Backbone.View

  functionLog: (name) ->
    console.log name

  valueHasChanged: ( ->
    latestValue = []
    return (value, id) ->
      if value == latestValue[id]
        result = false
      else
        latestValue[id] = value
        result = true

      return result
  )()

  itemTmpl: (->
    result = ''
    jQuery.ajax
      url: 'site/templates/item.html'
      async: false
      success: (data) ->
        result = data
    result
  )()