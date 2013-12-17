class ItemView extends PxwrkViewLib

  tagName: 'li'

  initialize: ->
    _.bindAll @

    if !@model
      throw new Error('model is required')

    if @model.constructor.name != 'Item'
      throw new Error('model is not an instance of Item')


  events:
    'click': 'showItemDetail'

  render: ->
    pxwrk.functionLog 'ItemView.render()'
    if @itemTmpl
      jQuery(@el).html( _.template( @itemTmpl, @model.toJSON() ) )
    else
      jQuery(@el).html( 'Error: Missing Template' )
    @

  unrender: ->
    pxwrk.functionLog 'ItemView.unrender()'
    @remove()
    @

  renderItemDetailView: ->
    itemDetailView = new ItemDetailView
      model: @model
    return itemDetailView.render()

  showItemDetail: ->
    @renderItemDetailView().show()
