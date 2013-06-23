class ItemView extends pxwrkHelpersForViews

  tagName: 'li'

  itemDetailView: new ItemDetailView

  initialize: ->
    _.bindAll @

  events:
    'click': 'itemDetail'

  itemDetail: ->
    console.log 'itemDetail()'

    #@itemDetailView.render()

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