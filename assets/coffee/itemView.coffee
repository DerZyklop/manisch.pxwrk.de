class ItemView extends pxwrkHelpersForViews

  tagName: 'li'

  className: (->
    counter = 0
    return ->
      counter++
      if counter%2 == 0
        return 'even'
      else
        return 'odd'
  )()

  initialize: ->
    _.bindAll @

  render: (tmpl) ->
    #_.templateSettings.interpolate : /\{\{(.+?)\}\}/g

    if tmpl
      jQuery(@el).html( _.template( tmpl, @model.toJSON() ) )
    else
      jQuery(@el).html( 'Error: Missing Template' )

    @

  unrender: ->
    #@functionLog 'unrender()'
    $(@el).remove()