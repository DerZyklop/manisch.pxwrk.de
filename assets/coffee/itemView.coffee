class ItemView extends pxwrkHelpersForViews

  tagName: 'li'

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