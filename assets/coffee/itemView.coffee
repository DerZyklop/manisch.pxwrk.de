class ItemView extends pxwrkHelpersForViews

  tagName: 'li'

  #itemDetailView: new ItemDetailView

  initialize: ->
    _.bindAll @

#  events:
#    'click': 'itemDetail'
#
#  itemDetail: ->
#    @itemDetailView.render()

  render: (tmpl) ->
    @functionLog 'ItemView.render()'
    if tmpl
      jQuery(@el).html( _.template( tmpl, @model.toJSON() ) )
    else
      jQuery(@el).html( 'Error: Missing Template' )

    @

  unrender: ->
    @functionLog 'ItemView.unrender()'
    $(@el).remove()