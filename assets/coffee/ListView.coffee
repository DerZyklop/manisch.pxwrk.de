class ListView extends pxwrkHelpersForViews

  el: '#list'

  allTranslations: new List

  # TODO: 'currentlyVisible' ersetzt das hier eigentlich:
  requestedTranslations: new List

  getItemsBySearch: (searchParam = false) ->
    @functionLog 'getItemsBySearch('+searchParam+')'

    @removeAllItems()

    searchResult = @requestedTranslations.search(searchParam)

    console.log searchResult.models

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

    itemView = new ItemView
      model: item
      tmpl: @itemTmpl

    $(@el).append( itemView.render(@itemTmpl).el )

  appendItems: (collection) ->

    @requestedTranslations = collection

    html = ''
    _.each collection.models, (item) =>
      item.set 'currentlyVisible', true

      itemView = new ItemView
        model: item

      html += itemView.render(@itemTmpl).el.outerHTML

    jQuery(@el).append( html )

  removeAllItems: ->
    _.each @allTranslations.models, (item) ->
      item.set 'currentlyVisible', false
    jQuery(@el).html('')

  itemTmpl: (->
    t = false
    return (=>
      if t == false
        console.log 'get the item.html'
        jQuery.ajax
          url: 'site/templates/item.html'
          async: false
          dataType: 'html'
          success: (data) =>
            t = data
          error: ->
            @functionLog 'error'
      return t
    )()
  )()

  initialize: ->

  render: ->
    @functionLog 'render()'