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
    t = false
    return (=>
      if t == false
        jQuery.ajax
          url: 'site/templates/item.html'
          async: false
          dataType: 'html'
          success: (data) =>
            t = data
          error: ->
            @functionLog 'error'
      return t
    )()
  )()
