class PxwrkLib

  functionLog: (name) ->
    #console.log name
    return name

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