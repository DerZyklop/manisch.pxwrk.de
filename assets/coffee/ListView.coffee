class ListView extends pxwrkHelpersForViews

  el: '#list-view ul'

  allTranslations: new List

  # TODO: 'currentlyVisible' ersetzt das hier eigentlich:
  categoryTranslations: new List

  visibleTranslations: new List

  getItemsBySearch: (searchParam = false) ->
    @functionLog 'getItemsBySearch('+searchParam+')'

    @unrender()

    @visibleTranslations.reset( @categoryTranslations.search(searchParam).toJSON() )
    
    @

  getItemsByCategory: (categoryName) ->
    @functionLog 'getItemsByCategory()'

    jQuery('.sort.active').removeClass 'active'
    jQuery('#'+categoryName).addClass 'active'

    @unrender()

    @categoryTranslations = @allTranslations.byCategory(categoryName)

    @visibleTranslations.reset( @categoryTranslations.toJSON() )
    
    @

  openItemDetail: (id) ->
    console.log '@categoryTranslations.where(id, 5)'

    itemView = new ItemView
      model: @categoryTranslations.findWhere({id:id})

    itemView.openItemDetail()

  appendItem: (item) ->
    @functionLog 'appendItem()'

    itemView = new ItemView
      model: item
      className: @getClassName(item, item.collection.length)

    $(@el).append( itemView.render().el )


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

  appendItems: ->
    @functionLog 'appendItems()'

    html = ''
    _.each @visibleTranslations.models, (item) =>
      @appendItem item

  initialize: ->

  deactivateInfo: () ->
    if !jQuery('#bottom-list-info').hasClass 'inactive'
      jQuery('#bottom-list-info').addClass 'inactive'

  render: ->
    @functionLog 'render()'

    @deactivateInfo()

    @appendItems()

  unrender: ->
    jQuery(@el).html('')
