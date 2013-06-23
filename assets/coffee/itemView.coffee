class ItemView extends pxwrkHelpersForViews

  tagName: 'li'

  initialize: ->
    _.bindAll @

  events:
    'click': 'itemDetail'

  itemDetail: ->
    @itemDetailView = new ItemDetailView
      model: @model
    @itemDetailView.render()

  render: (tmpl) ->
    @functionLog 'ItemView.render()'
    if tmpl
      jQuery(@el).html( _.template( tmpl, @model.toJSON() ) )
    else
      jQuery(@el).html( 'Error: Missing Template' )

    @

  unrender: ->
    @functionLog 'ItemView.unrender()'
    @remove()