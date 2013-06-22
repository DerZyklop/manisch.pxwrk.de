class ListView extends pxwrkHelpersForViews

  el: '#list'

  allTranslations: new List

  # TODO: 'currentlyVisible' ersetzt das hier eigentlich:
  requestedTranslations: new List

  getItemsBySearch: (searchParam = false) ->
    @functionLog 'getItemsBySearch('+searchParam+')'

    @removeAllItems()

    @requestedTranslations.search(searchParam)

  getItemsByCategory: (categoryName) ->
    @functionLog 'getItemsByCategory()'

    jQuery('.sort.active').removeClass 'active'
    jQuery('#'+categoryName).addClass 'active'

    @removeAllItems()

    @requestedTranslations = @allTranslations.byCategory(categoryName)

  appendItem: (item) ->
    @functionLog 'appendItem()'

    itemView = new ItemView
      model: item
      tmpl: @itemTmpl

    $(@el).append( itemView.render(@itemTmpl).el )


  getClassName: (->
    latestTranslation = false
    translationsCounter = 0
    itemsCounter = 0
    return (item, collection) ->
      if (latestTranslation.german == item.toJSON().german)
        result = 'same-german'
      else if (latestTranslation.manisch == item.toJSON().manisch)
        result = 'same-manisch'
      else
        result = ''
        translationsCounter++

      if translationsCounter%2 == 0
        result += ' even'
      else
        result += ' odd'

      itemsCounter++
      if itemsCounter == collection.length
        translationsCounter = 0
        itemsCounter = 0
        latestTranslation = false
      else
        latestTranslation = item.toJSON()

      return result
  )()

  appendItems: (collection) ->

    console.log 'collection: '+collection

    html = ''
    _.each collection.models, (item) =>
      item.set 'currentlyVisible', true

      itemView = new ItemView
        model: item
        className: @getClassName(item, collection)

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