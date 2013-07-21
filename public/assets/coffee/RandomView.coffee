class RandomView extends pxwrkHelpersForViews

  el: '#list-view ul'

  visibleItems: new List

  showItemDetail: (params) ->
    items = translations.category(params.category).search(params.search)
    item = items.findWhere({id:params.id})

    itemDetailView = new ItemDetailView
      model: item
    itemDetailView.show()

  appendItem: (item) ->
    itemView = new ItemView
      model: item
      className: @getClassName(item, item.collection.length)

    $(@el).append( itemView.render().el )



  deactivateInfo: () ->
    el = jQuery('#bottom-list-info')
    if !el.hasClass 'inactive' then el.addClass 'inactive'



  render: ->
    @functionLog 'render()'

    @deactivateInfo()

    #@appendItems()

  unrender: ->
    jQuery(@el).html('')
