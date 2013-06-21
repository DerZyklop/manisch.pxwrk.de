class ListView extends pxwrkHelpersForViews

  el: '#list'

  allTranslations: new List

  # TODO: 'currentlyVisible' ersetzt das hier eigentlich:
  requestedTranslations: new List

  getItemsBySearch: (searchParam = false) ->
    @functionLog 'getItemsBySearch('+searchParam+')'

    @removeAllItems()

    searchResult = @requestedTranslations.search(searchParam)

    _.each searchResult.models, (item) =>
      @appendItem(item)

  getItemsByCategory: (categoryName) ->
    @functionLog 'getItemsByCategory()'

    jQuery('.sort.active').removeClass 'active'
    jQuery('#'+categoryName).addClass 'active'

    @removeAllItems()

    @allTranslations.byCategory(categoryName)

  appendItem: (item) ->
    @functionLog 'appendItem()'

    item_view = new ItemView
      model: item

    $(@el).append( item_view.render().el )

  appendItems: (collection) ->

    @requestedTranslations = collection

    html = ''
    _.each collection.models, (item) =>
      item.set 'currentlyVisible', true

      item_view = new ItemView
        model: item

      html += item_view.render().el.outerHTML

    jQuery(@el).append( html )

  removeAllItems: ->
    _.each @allTranslations.models, (item) ->
      item.set 'currentlyVisible', false
    jQuery(@el).html('')

  render: ->
    @functionLog 'render()'