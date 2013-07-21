class ItemView extends pxwrkHelpersForViews

  tagName: 'li'

  initialize: ->
    _.bindAll @

  events:
    'click': 'showItemDetail'

  showItemDetail: ->
    itemDetailView = new ItemDetailView
      model: @model
    itemDetailView.show()

  render: ->
    @functionLog 'ItemView.render()'
    if @itemTmpl
      jQuery(@el).html( _.template( @itemTmpl, @model.toJSON() ) )
    else
      jQuery(@el).html( 'Error: Missing Template' )

    @

  unrender: ->
    @functionLog 'ItemView.unrender()'
    @remove()
