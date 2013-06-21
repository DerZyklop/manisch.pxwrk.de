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