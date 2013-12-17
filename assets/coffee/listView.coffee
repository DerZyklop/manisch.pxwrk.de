class ListView extends PxwrkViewLib

  tagName: 'ul'
  visibleItems: new List

  getFilteredList: (params) ->
    @unrender()

    items = translations.category(params.category).search(params.search)
    @visibleItems.reset items.toJSON()

    @


  getClassName: (->
    latestTranslation = false
    translationsCounter = 0
    itemsCounter = 0
    return (item, amount) ->
      if latestTranslation.german == item.toJSON().german
        result = 'same-german'
      else if latestTranslation.manisch == item.toJSON().manisch
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

  # initialize: ->
  #   @visibleItems.bind('change', @render);


  appendItem: (item) ->

    itemView = new ItemView
      model: item
      className: @getClassName(item, item.collection.length)

    $(@el).append( itemView.render().el )



  appendItems: ->
    _.each @visibleItems.models, (item) =>
      @appendItem item

    @

  show: ->
    app.$el.find('#list-view').append(@el)

  deactivateInfo: () ->
    el = jQuery('#bottom-list-info')
    if !el.hasClass 'inactive' then el.addClass 'inactive'



  render: ->
    pxwrk.functionLog 'render()'

    @deactivateInfo()

    @appendItems().show()

    @

  unrender: ->
    jQuery(@el).html('')
