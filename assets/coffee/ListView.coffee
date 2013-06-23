class ListView extends pxwrkHelpersForViews

  el: '#list'

  allTranslations: new List

  # TODO: 'currentlyVisible' ersetzt das hier eigentlich:
  categoryTranslations: new List

  visibleTranslations: new List

  getItemsBySearch: (searchParam = false) ->
    @functionLog 'getItemsBySearch('+searchParam+')'

    @removeAllItems()

    @visibleTranslations.reset( @categoryTranslations.search(searchParam).toJSON() )

  getItemsByCategory: (categoryName) ->
    @functionLog 'getItemsByCategory()'

    jQuery('.sort.active').removeClass 'active'
    jQuery('#'+categoryName).addClass 'active'

    @removeAllItems()

    @categoryTranslations = @allTranslations.byCategory(categoryName)

    @visibleTranslations.reset( @categoryTranslations.toJSON() )

  appendItem: (item) ->
    @functionLog 'appendItem()'

    itemView = new ItemView
      model: item
      tmpl: @itemTmpl
      className: @getClassName(item, item.collection.length)

    $(@el).append( itemView.render(@itemTmpl).el )


  getClassName: (->
    latestTranslation = false
    translationsCounter = 0
    itemsCounter = 0
    return (item, amount) ->
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
      if itemsCounter == amount
        translationsCounter = 0
        itemsCounter = 0
        latestTranslation = false
      else
        latestTranslation = item.toJSON()

      return result
  )()

  appendItems: (collection) ->
    @functionLog 'appendItems()'

    html = ''
    _.each collection.models, (item) =>
      @appendItem item

  removeAllItems: ->
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
    jQuery('#list').html('<ul></ul>')
    @el = '#list ul'

    @visibleTranslations.on 'reset', (collection) =>
      @appendItems collection

  render: ->
    @functionLog 'render()'